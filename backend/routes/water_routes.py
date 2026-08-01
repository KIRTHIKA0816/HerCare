from datetime import date as date_cls
from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.water import WaterLog

water_bp = Blueprint('water_bp', __name__)


@water_bp.route('/<int:user_id>/today', methods=['GET'])
def get_today_water(user_id):
    """Returns today's water log for the user, creating a zeroed one if none exists."""
    today = date_cls.today().isoformat()
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM water_log WHERE user_id = %s AND date = %s',
        (user_id, today)
    )
    row = cursor.fetchone()

    if row is None:
        cursor.execute(
            'INSERT INTO water_log (user_id, date, glasses, goal) VALUES (%s, %s, 0, 8)',
            (user_id, today)
        )
        conn.commit()
        cursor.execute(
            'SELECT * FROM water_log WHERE user_id = %s AND date = %s',
            (user_id, today)
        )
        row = cursor.fetchone()

    cursor.close()
    conn.close()
    return jsonify(WaterLog.from_row(row).to_dict()), 200


@water_bp.route('/<int:user_id>/add', methods=['POST'])
def add_water(user_id):
    """
    Adds (or subtracts) glasses to today's total.
    Body: { "amount": 1 }  -- can be negative to undo a tap
    """
    data = request.get_json() or {}
    amount = data.get('amount', 1)
    today = date_cls.today().isoformat()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO water_log (user_id, date, glasses, goal)
           VALUES (%s, %s, GREATEST(%s, 0), 8)
           ON DUPLICATE KEY UPDATE glasses = GREATEST(glasses + %s, 0)''',
        (user_id, today, amount, amount)
    )
    conn.commit()

    cursor.execute(
        'SELECT * FROM water_log WHERE user_id = %s AND date = %s',
        (user_id, today)
    )
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    return jsonify(WaterLog.from_row(row).to_dict()), 200


@water_bp.route('/<int:user_id>/goal', methods=['PUT'])
def update_goal(user_id):
    data = request.get_json() or {}
    goal = data.get('goal')
    if not goal or goal <= 0:
        return jsonify({'error': 'A valid goal is required'}), 400

    today = date_cls.today().isoformat()
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO water_log (user_id, date, glasses, goal)
           VALUES (%s, %s, 0, %s)
           ON DUPLICATE KEY UPDATE goal = %s''',
        (user_id, today, goal, goal)
    )
    conn.commit()

    cursor.execute(
        'SELECT * FROM water_log WHERE user_id = %s AND date = %s',
        (user_id, today)
    )
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    return jsonify(WaterLog.from_row(row).to_dict()), 200


@water_bp.route('/<int:user_id>/history', methods=['GET'])
def get_water_history(user_id):
    """Last 7 days of water intake, most recent first."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''SELECT * FROM water_log
           WHERE user_id = %s
           ORDER BY date DESC
           LIMIT 7''',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    history = [WaterLog.from_row(r).to_dict() for r in rows]
    return jsonify(history), 200
