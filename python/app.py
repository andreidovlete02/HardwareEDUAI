from flask import Flask
from flask_cors import CORS
from flask_mysqldb import MySQL
from auth_routes import auth_bp
from quiz_routes import quiz_bp
from ai_routes import ai_bp
from profile_routes import profile_bp
from feedback_routes import feedback_bp
from achievements_routes import achievements_bp

# Configuration class
class Config:
    MYSQL_HOST = 'localhost'
    MYSQL_USER = 'root'
    MYSQL_PASSWORD = ''
    MYSQL_DB = 'test'

# Initialize Flask app
app = Flask(__name__)
CORS(app)
app.config.from_object(Config)

# Initialize MySQL
mysql = MySQL()
mysql.init_app(app)

# Register blueprints
app.register_blueprint(auth_bp)
app.register_blueprint(quiz_bp)
app.register_blueprint(ai_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(feedback_bp)
app.register_blueprint(achievements_bp)

if __name__ == '__main__':
    app.run(debug=True)
