from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.pcod import PCOD

pcod_bp = Blueprint('pcod_bp', __name__)


@pcod_bp.route('', methods=['POST'])
def add_pcod_entry():
    data = request.get_json()
    user_id = data.get('user_id')
    date = data.get('date')
    weight_change = data.get('weight_change')
    sleep_hours = data.get('sleep_hours')
    stress_level = data.get('stress_level')
    exercise_done = data.get('exercise_done', False)
    water_intake = data.get('water_intake')

    if not user_id or not date:
        return jsonify({'error': 'user_id and date are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO pcod_tracker
           (user_id, date, weight_change, sleep_hours, stress_level, exercise_done, water_intake)
           VALUES (%s, %s, %s, %s, %s, %s, %s)''',
        (user_id, date, weight_change, sleep_hours, stress_level, exercise_done, water_intake)
    )
    conn.commit()
    new_id = cursor.lastrowid

    cursor.execute('SELECT * FROM pcod_tracker WHERE pcod_id = %s', (new_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    entry = PCOD.from_row(row)
    return jsonify(entry.to_dict()), 201


@pcod_bp.route('/<int:user_id>', methods=['GET'])
def get_pcod_entries(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM pcod_tracker WHERE user_id = %s ORDER BY date DESC',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    entries = [PCOD.from_row(r).to_dict() for r in rows]
    return jsonify(entries), 200


@pcod_bp.route('/summary/<int:user_id>', methods=['GET'])
def get_pcod_summary(user_id):
    """Monthly averages for the PCOD progress chart."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''SELECT
               AVG(weight_change) AS avg_weight_change,
               AVG(sleep_hours) AS avg_sleep_hours,
               AVG(stress_level) AS avg_stress_level,
               AVG(water_intake) AS avg_water_intake,
               SUM(exercise_done) AS exercise_days
           FROM pcod_tracker
           WHERE user_id = %s
             AND date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)''',
        (user_id,)
    )
    summary = cursor.fetchone()
    cursor.close()
    conn.close()
    return jsonify(summary), 200
