from datetime import datetime, timedelta
from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.period import Period

period_bp = Blueprint('period_bp', __name__)


@period_bp.route('', methods=['POST'])
def add_period():
    data = request.get_json()
    user_id = data.get('user_id')
    start_date = data.get('start_date')
    end_date = data.get('end_date')
    cycle_length = data.get('cycle_length', 28)
    flow_level = data.get('flow_level', 'Medium')

    if not user_id or not start_date:
        return jsonify({'error': 'user_id and start_date are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO period_tracker (user_id, start_date, end_date, cycle_length, flow_level)
           VALUES (%s, %s, %s, %s, %s)''',
        (user_id, start_date, end_date, cycle_length, flow_level)
    )
    conn.commit()
    new_id = cursor.lastrowid

    cursor.execute('SELECT * FROM period_tracker WHERE period_id = %s', (new_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    period = Period.from_row(row)
    return jsonify(period.to_dict()), 201


@period_bp.route('/<int:user_id>', methods=['GET'])
def get_periods(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM period_tracker WHERE user_id = %s ORDER BY start_date DESC',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    periods = [Period.from_row(r).to_dict() for r in rows]
    return jsonify(periods), 200


@period_bp.route('/<int:period_id>', methods=['DELETE'])
def delete_period(period_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM period_tracker WHERE period_id = %s', (period_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Period record deleted'}), 200


@period_bp.route('/predict/<int:user_id>', methods=['GET'])
def predict_next_period(user_id):
    """
    Predicts the next period start date and current cycle day
    based on the most recent logged period.
    """
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM period_tracker WHERE user_id = %s ORDER BY start_date DESC LIMIT 1',
        (user_id,)
    )
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    if row is None:
        return jsonify({'error': 'No period history found for this user'}), 404

    last_period = Period.from_row(row)
    start = last_period.start_date
    if isinstance(start, str):
        start = datetime.strptime(start, '%Y-%m-%d').date()

    cycle_length = last_period.cycle_length or 28
    next_period_date = start + timedelta(days=cycle_length)
    today = datetime.now().date()
    cycle_day = (today - start).days + 1

    return jsonify({
        'last_period_start': str(start),
        'cycle_length': cycle_length,
        'next_period_date': str(next_period_date),
        'current_cycle_day': cycle_day,
        'days_until_next_period': (next_period_date - today).days,
    }), 200
