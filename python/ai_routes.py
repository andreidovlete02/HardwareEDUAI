from flask import Blueprint, request, jsonify
from extensions import mysql
import json
from datetime import datetime

ai_bp = Blueprint('ai', __name__)

@ai_bp.route('/save_ai_response', methods=['POST'])
def save_ai_response():
    data = request.get_json()
    user_id = data.get('user_id')
    explanations = data.get('explanations')
    created_at = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    if not user_id or not explanations:
        return jsonify({'message': 'User ID and Explanations are required'}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO ai_response (user_id, explanations, created_at) VALUES (%s, %s, %s)", 
                    (user_id, json.dumps(explanations), created_at))
        mysql.connection.commit()
        cur.close()

        return jsonify({'message': 'AI response saved successfully'}), 201
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500

@ai_bp.route('/get_ai_responses', methods=['GET'])
def get_ai_responses():
    user_id = request.args.get('user_id')

    if not user_id:
        return jsonify({'message': 'User ID is required'}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM ai_response WHERE user_id = %s ORDER BY created_at DESC", (user_id,))
        rows = cur.fetchall()
        cur.close()

        responses = [{'id': row[0], 'user_id': row[1], 'explanations': json.loads(row[2]), 
                      'created_at': row[3].strftime('%Y-%m-%d %H:%M:%S')} for row in rows]

        return jsonify(responses), 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500
