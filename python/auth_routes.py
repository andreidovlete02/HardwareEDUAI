from flask import Blueprint, request, jsonify
from extensions import mysql
import bcrypt

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    # Check if email already exists
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM user WHERE email = %s", (email,))
    existing_user = cur.fetchone()
    cur.close()

    if existing_user:
        return jsonify({'message': 'Email already exists'}), 409

    # Hash the password
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Insert new user
    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO user (email, password) VALUES (%s, %s)", (email, hashed_password))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'User registered successfully'}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'message': 'Email and password are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM user WHERE email = %s", (email,))
    user = cur.fetchone()
    cur.close()

    if user and bcrypt.checkpw(password.encode('utf-8'), user[2].encode('utf-8')):  
        user_id = user[0]  # Assuming the user ID is in the first column
        return jsonify({'message': 'Login successful', 'userID': user_id}), 200
    else:
        return jsonify({'message': 'Invalid email or password'}), 401

    return jsonify({'message': 'Unexpected error occurred'}), 500  
