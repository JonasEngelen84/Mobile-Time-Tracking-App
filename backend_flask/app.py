from flask import Flask
from backend_flask.routes.login_route import login_blueprint
from backend_flask.routes.register_route import register_blueprint
from backend_flask.routes.time_tracking_route import time_tracking_blueprint

def create_app():
    """
    Initialisiert und konfiguriert die Flask-Applikation (Backend).
    Registriert alle Blueprints (also die API-Endpunkte für Login, Registrierung usw.)
    """
    app_instance = Flask(__name__)

    # Optional: Konfigurationswerte (z. B. für Sessions, Sicherheit)
    app_instance.config['SECRET_KEY'] = 'your-secret-key'  # Wird z. B. für sichere Cookies benötigt

    # Registrierung der API-Routen über Blueprints
    # Alle Login- und Registrierungsendpunkte sind über den Pfad /api/auth erreichbar
    app_instance.register_blueprint(login_blueprint)
    app_instance.register_blueprint(register_blueprint)
    app_instance.register_blueprint(time_tracking_blueprint, url_prefix='/api/time')

    return app_instance

if __name__ == '__main__':
    # Wenn die Datei direkt ausgeführt wird, starte den lokalen Webserver
    app = create_app()
    app.run(debug=True)  # Debug-Modus: sollte in Produktion deaktiviert werden
