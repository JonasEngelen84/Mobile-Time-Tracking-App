from flask import Blueprint, request, jsonify
from services.auth_services import login as login_logic
from services.auth_services import register as register_logic

auth_blueprint = Blueprint("login", __name__)

@auth_blueprint.route("/login", methods=["POST"])
def login_route():
    data = request.json
    user = data.get("username")
    password = data.get("password")

    success, report = login_logic(user, password)
    return jsonify({"success": success, "message": report})

@auth_blueprint.route("/register", methods=["POST"])
def register_route():
    data = request.json
    user = data.get("username")
    password = data.get("password")
    password_repetition = data.get("password_repetition")

    success, report = register_logic(user, password, password_repetition)
    return jsonify({"success": success, "message": report})