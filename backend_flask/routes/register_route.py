from flask import Blueprint, request, jsonify
from services.auth_services import register as register_logic

register_blueprint = Blueprint("register", __name__)

""" REST-API """
@register_blueprint.route("/register", methods=["POST"])
def register_route():
    data = request.json
    user = data.get("username")
    password = data.get("password")
    password_repetition = data.get("password_repetition")

    success, report = register_logic(user, password, password_repetition)
    return jsonify({"success": success, "message": report})
