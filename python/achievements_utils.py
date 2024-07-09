from extensions import mysql

def get_quiz_count(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(DISTINCT quiz_id) FROM grades WHERE userID = %s", (user_id,))
    unique_quizzes = cur.fetchone()[0]
    cur.close()
    return unique_quizzes

def get_feedback_count(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM feedback WHERE user_id = %s", (user_id,))
    feedbacks = cur.fetchone()[0]
    cur.close()
    return feedbacks

def check_profile_modified(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM profile_extended WHERE user_id = %s AND username IS NOT NULL AND username != ''", (user_id,))
    profile_modifies = cur.fetchone()[0]
    cur.close()
    return profile_modifies

def get_ai_response_count(user_id):
    cur = mysql.connection.cursor()
    cur.execute("SELECT COUNT(*) FROM ai_response WHERE user_id = %s", (user_id,))
    ai_responses = cur.fetchone()[0]
    cur.close()
    return ai_responses
