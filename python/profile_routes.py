from flask import Blueprint, request, jsonify
from extensions import mysql

profile_bp = Blueprint('profile', __name__)

@profile_bp.route('/profile/<int:user_id>', methods=['GET'])
def get_profile(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT username, phone_number, country FROM profile_extended WHERE user_id = %s", (user_id,))
    user = cur.fetchone()
    cur.close()

    if user:
        return jsonify({'username': user[0], 'phone_number': user[1], 'country': user[2]})
    return jsonify({'message': 'User not found'}), 404

@profile_bp.route('/profile/<int:user_id>', methods=['PUT'])
def update_profile(user_id):
    data = request.get_json()
    username = data.get('username')
    phone_number = data.get('phone_number')
    country = data.get('country')

    if not username or not phone_number or not country:
        return jsonify({'message': 'Username, Phone Number, and Country are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM profile_extended WHERE user_id = %s", (user_id,))
    user = cur.fetchone()

    if user:
        cur.execute("""
            UPDATE profile_extended 
            SET username = %s, phone_number = %s, country = %s 
            WHERE user_id = %s
        """, (username, phone_number, country, user_id))
    else:
        cur.execute("""
            INSERT INTO profile_extended (user_id, username, phone_number, country) 
            VALUES (%s, %s, %s, %s)
        """, (user_id, username, phone_number, country))
    
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Profile updated successfully'}), 200
