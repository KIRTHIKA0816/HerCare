from flask import Flask
from flask_cors import CORS
from database import init_db
from routes.user_routes import user_bp
from routes.period_routes import period_bp
from routes.symptom_routes import symptom_bp
from routes.pcod_routes import pcod_bp
from routes.reminder_routes import reminder_bp
from routes.food_routes import food_bp
from routes.water_routes import water_bp


def create_app():
    app = Flask(__name__)

    CORS(
        app,
        resources={r"/api/*": {"origins": "*"}},
        methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        allow_headers=["Content-Type"]
    )

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/api/users')

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/api/users')
    app.register_blueprint(period_bp, url_prefix='/api/periods')
    app.register_blueprint(symptom_bp, url_prefix='/api/symptoms')
    app.register_blueprint(pcod_bp, url_prefix='/api/pcod')
    app.register_blueprint(reminder_bp, url_prefix='/api/reminders')
    app.register_blueprint(food_bp, url_prefix='/api/food')
    app.register_blueprint(water_bp, url_prefix='/api/water')

    @app.route('/api/health', methods=['GET'])
    def health_check():
        return {'status': 'ok', 'service': 'HerCare API'}, 200

    return app


if __name__ == '__main__':
    init_db()
    app = create_app()
    app.run(debug=True, host='0.0.0.0', port=5000)
