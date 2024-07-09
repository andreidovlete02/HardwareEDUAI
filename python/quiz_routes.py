from flask import Blueprint, request, jsonify
from extensions import mysql
from datetime import datetime

quiz_bp = Blueprint('quiz', __name__)

@quiz_bp.route('/grade_quiz', methods=['POST'])
def grade_quiz():
    data = request.get_json()
    quiz_id = data.get('quiz_id')
    userID = data.get('user_id')
    score = data.get('score')

    if quiz_id is None or userID is None or score is None:
        return jsonify({'message': 'Quiz ID, User ID, and Score are required'}), 400

    created_at = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO grades (quiz_id, userID, score, created_at) VALUES (%s, %s, %s, %s)", 
                (quiz_id, userID, score, created_at))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Quiz grade stored successfully'}), 201

@quiz_bp.route('/leaderboard/<int:quiz_id>', methods=['GET'])
def get_leaderboard(quiz_id):
    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT u.email, MAX(g.score)
            FROM grades g
            JOIN user u ON g.userID = u.userID
            WHERE g.quiz_id = %s
            GROUP BY u.email
            ORDER BY MAX(g.score) DESC
        """, (quiz_id,))
        leaderboard_data = cur.fetchall()
        cur.close()

        leaderboard_list = [{'email': entry[0], 'score': entry[1]} for entry in leaderboard_data]

        return jsonify({'leaderboard': leaderboard_list}), 200
    except Exception as e:
        print("Error:", e)
        return jsonify({'error': 'Internal server error'}), 500

@quiz_bp.route('/get_quiz_attempts', methods=['GET'])
def get_quiz_attempts():
    user_id = request.args.get('user_id')
    quiz_id = request.args.get('quiz_id')

    if not user_id or not quiz_id:
        return jsonify({'message': 'User ID and Quiz ID are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM grades WHERE userID = %s AND quiz_id = %s", (user_id, quiz_id))
    attempts = cur.fetchone()[0]
    cur.close()

    return jsonify({'attempts': attempts}), 200

@quiz_bp.route('/get_quiz_history', methods=['GET'])
def get_quiz_history():
    user_id = request.args.get('user_id')
    quiz_id = request.args.get('quiz_id')

    if not user_id or not quiz_id:
        return jsonify({'message': 'User ID and Quiz ID are required'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT score, DATE_FORMAT(created_at, '%%Y-%%m-%%d %%H:%%i:%%s') as date FROM grades WHERE userID = %s AND quiz_id = %s ORDER BY created_at DESC", (user_id, quiz_id))
    history = cur.fetchall()
    cur.close()

    history_list = [{'score': item[0], 'date': item[1]} for item in history]

    return jsonify(history_list), 200
