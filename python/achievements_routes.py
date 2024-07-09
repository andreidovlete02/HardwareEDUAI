from flask import Blueprint, jsonify
from extensions import mysql

from achievements_utils import get_quiz_count, get_feedback_count, check_profile_modified, get_ai_response_count

achievements_bp = Blueprint('achievements', __name__)

@achievements_bp.route('/achievements/<int:user_id>', methods=['GET'])
def get_achievements(user_id):
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT achievementID, timestamp FROM achievements WHERE userID = %s", (user_id,))
        achievement_rows = cur.fetchall()
        achievements = {row[0]: {'timestamp': row[1].strftime('%Y-%m-%d %H:%M:%S')} for row in achievement_rows}
        cur.close()

        quiz_count = get_quiz_count(user_id)
        feedback_count = get_feedback_count(user_id)
        profile_modified = check_profile_modified(user_id)
        ai_response_count = get_ai_response_count(user_id)
        
        return jsonify({
            'achievements': achievements,
            'quizCount': quiz_count,
            'feedbackCount': feedback_count,
            'profileModified': profile_modified,
            'aiResponseCount': ai_response_count,
        }), 200
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'error': 'Internal server error'}), 500
