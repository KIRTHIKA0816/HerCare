from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.reminder import Reminder

reminder_bp = Blueprint('reminder_bp', __name__)


@reminder_bp.route('', methods=['POST'])
def add_reminder():
    data = request.get_json()
    user_id = data.get('user_id')
    reminder_type = data.get('reminder_type')
    reminder_date = data.get('reminder_date')
    status = data.get('status', 'Pending')

    if not user_id or not reminder_type or not reminder_date:
        return jsonify({'error': 'user_id, reminder_type and reminder_date are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO reminders (user_id, reminder_type, reminder_date, status)
           VALUES (%s, %s, %s, %s)''',
        (user_id, reminder_type, reminder_date, status)
    )
    conn.commit()
    new_id = cursor.lastrowid

    cursor.execute('SELECT * FROM reminders WHERE reminder_id = %s', (new_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    reminder = Reminder.from_row(row)
    return jsonify(reminder.to_dict()), 201


@reminder_bp.route('/<int:user_id>', methods=['GET'])
def get_reminders(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM reminders WHERE user_id = %s ORDER BY reminder_date ASC',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    reminders = [Reminder.from_row(r).to_dict() for r in rows]
    return jsonify(reminders), 200


@reminder_bp.route('/<int:reminder_id>', methods=['PUT'])
def update_reminder_status(reminder_id):
    data = request.get_json()
    status = data.get('status')
    if status not in ('Pending', 'Completed', 'Cancelled'):
        return jsonify({'error': 'Invalid status value'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'UPDATE reminders SET status = %s WHERE reminder_id = %s',
        (status, reminder_id)
    )
    conn.commit()

    cursor.execute('SELECT * FROM reminders WHERE reminder_id = %s', (reminder_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    reminder = Reminder.from_row(row)
    if reminder is None:
        return jsonify({'error': 'Reminder not found'}), 404
    return jsonify(reminder.to_dict()), 200


@reminder_bp.route('/<int:reminder_id>', methods=['DELETE'])
def delete_reminder(reminder_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM reminders WHERE reminder_id = %s', (reminder_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Reminder deleted'}), 200
