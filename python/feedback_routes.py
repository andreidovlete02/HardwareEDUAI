from flask import Blueprint, request, jsonify
from extensions import mysql

feedback_bp = Blueprint('feedback', __name__)

@feedback_bp.route('/feedback', methods=['POST'])
def save_feedback():
    data = request.get_json()
    user_id = data.get('user_id')
    feedback = data.get('feedback')

    if not user_id or not feedback:
        return jsonify({'message': 'User ID and feedback are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO feedback (user_id, feedback) VALUES (%s, %s)", (user_id, feedback))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Feedback submitted successfully'}), 201
