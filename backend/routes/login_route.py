from flask import Blueprint, request, jsonify
from backend.services.auth_services import login as login_logic

login_blueprint = Blueprint("login", __name__)

""" REST-API """
@login_blueprint.route("/login", methods=["POST"])
def login_route():
    data = request.json
    user = data.get("user")
    password = data.get("password")

    success, report = login_logic(user, password)
    return jsonify({"success": success, "message": report})

