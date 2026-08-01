from flask import Blueprint, request, jsonify
from database import get_db_connection
from models.symptom import Symptom

symptom_bp = Blueprint('symptom_bp', __name__)


@symptom_bp.route('', methods=['POST'])
def add_symptom():
    data = request.get_json()
    user_id = data.get('user_id')
    date = data.get('date')
    pain_level = data.get('pain_level')
    mood = data.get('mood')
    acne = data.get('acne', False)
    hair_fall = data.get('hair_fall', False)
    cramps = data.get('cramps', False)
    notes = data.get('notes')

    if not user_id or not date:
        return jsonify({'error': 'user_id and date are required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        '''INSERT INTO symptoms (user_id, date, pain_level, mood, acne, hair_fall, cramps, notes)
           VALUES (%s, %s, %s, %s, %s, %s, %s, %s)''',
        (user_id, date, pain_level, mood, acne, hair_fall, cramps, notes)
    )
    conn.commit()
    new_id = cursor.lastrowid

    cursor.execute('SELECT * FROM symptoms WHERE symptom_id = %s', (new_id,))
    row = cursor.fetchone()
    cursor.close()
    conn.close()

    symptom = Symptom.from_row(row)
    return jsonify(symptom.to_dict()), 201


@symptom_bp.route('/<int:user_id>', methods=['GET'])
def get_symptoms(user_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute(
        'SELECT * FROM symptoms WHERE user_id = %s ORDER BY date DESC',
        (user_id,)
    )
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    symptoms = [Symptom.from_row(r).to_dict() for r in rows]
    return jsonify(symptoms), 200


@symptom_bp.route('/<int:symptom_id>', methods=['DELETE'])
def delete_symptom(symptom_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM symptoms WHERE symptom_id = %s', (symptom_id,))
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Symptom record deleted'}), 200
