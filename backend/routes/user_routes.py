from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
from psycopg2.extras import RealDictCursor
from database import get_db_connection
from models.user import User

user_bp = Blueprint('user_bp', __name__)


@user_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    age = data.get('age')
    height = data.get('height')
    weight = data.get('weight')

    if not name or not email or not password:
        return jsonify({
            'error': 'name, email and password are required'
        }), 400

    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute(
            'SELECT * FROM users WHERE email = %s',
            (email,)
        )

        if cursor.fetchone():
            return jsonify({
                'error': 'Email already registered'
            }), 409

        hashed_pw = generate_password_hash(password)

        cursor.execute(
            '''
            INSERT INTO users
            (name, email, password, age, height, weight)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING user_id
            ''',
            (name, email, hashed_pw, age, height, weight)
        )

        new_id = cursor.fetchone()['user_id']
        conn.commit()

        cursor.execute(
            'SELECT * FROM users WHERE user_id = %s',
            (new_id,)
        )

        row = cursor.fetchone()

        user = User.from_row(row)

        return jsonify(user.to_dict()), 201

    except Exception as e:
        conn.rollback()
        print("REGISTER ERROR:", e)

        return jsonify({
            'error': str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@user_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()

    email = data.get('email')
    password = data.get('password')

    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute(
            'SELECT * FROM users WHERE email = %s',
            (email,)
        )

        row = cursor.fetchone()

        if row is None:
            return jsonify({
                'error': 'Invalid email or password'
            }), 401

        user = User.from_row(row)

        if not check_password_hash(user.password, password):
            return jsonify({
                'error': 'Invalid email or password'
            }), 401

        return jsonify(user.to_dict()), 200

    except Exception as e:
        print("LOGIN ERROR:", e)

        return jsonify({
            'error': str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@user_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):

    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        cursor.execute(
            'SELECT * FROM users WHERE user_id = %s',
            (user_id,)
        )

        row = cursor.fetchone()

        if row is None:
            return jsonify({
                'error': 'User not found'
            }), 404

        user = User.from_row(row)

        return jsonify(user.to_dict()), 200

    finally:
        cursor.close()
        conn.close()


@user_bp.route('/<int:user_id>', methods=['PUT'])
def update_user(user_id):

    data = request.get_json()

    fields = ['name', 'age', 'height', 'weight']

    updates = {
        f: data[f]
        for f in fields
        if f in data
    }

    if not updates:
        return jsonify({
            'error': 'No valid fields to update'
        }), 400

    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)

    try:
        set_clause = ', '.join(
            f'{k} = %s'
            for k in updates
        )

        values = list(updates.values()) + [user_id]

        cursor.execute(
            f'''
            UPDATE users
            SET {set_clause}
            WHERE user_id = %s
            ''',
            values
        )

        conn.commit()

        cursor.execute(
            'SELECT * FROM users WHERE user_id = %s',
            (user_id,)
        )

        row = cursor.fetchone()

        if row is None:
            return jsonify({
                'error': 'User not found'
            }), 404

        user = User.from_row(row)

        return jsonify(user.to_dict()), 200

    except Exception as e:
        conn.rollback()

        return jsonify({
            'error': str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()
