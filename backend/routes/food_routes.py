from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.food import Food

food_bp = Blueprint('food_bp', __name__)


@food_bp.route('', methods=['POST'])
def add_food_entry():
    data = request.get_json()
    user_id = data.get('user_id')
    date = data.get('date')
    meal_type = data.get('meal_type')
    description = data.get('description')

    if not user_id or not date or not meal_type:
        return jsonify({'error': 'user_id, date and meal_type are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO food_tracker (user_id, date, meal_type, description)
           VALUES (%s, %s, %s, %s)''',
        (user_id, date, meal_type, description)
    )
    conn.commit()
    new_id = cursor.lastrowid

    cursor.execute('SELECT * FROM food_tracker WHERE food_id = %s', (new_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    entry = Food.from_row(row)
    return jsonify(entry.to_dict()), 201


@food_bp.route('/<int:user_id>', methods=['GET'])
def get_food_entries(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM food_tracker WHERE user_id = %s ORDER BY date DESC',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    entries = [Food.from_row(r).to_dict() for r in rows]
    return jsonify(entries), 200


@food_bp.route('/<int:food_id>', methods=['DELETE'])
def delete_food_entry(food_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM food_tracker WHERE food_id = %s', (food_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Food entry deleted'}), 200
