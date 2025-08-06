from flask import Blueprint, request, jsonify
from backend_flask.services.auth_services import register as register_logic

register_blueprint = Blueprint("register", __name__)

""" REST-API """
@register_blueprint.route("/register", methods=["POST"])
def register_route():
    data = request.json
    user = data.get("user")
    password = data.get("password")
    password_repeat = data.get("password_repeat")

    success, report = register_logic(user, password, password_repeat)
    return jsonify({"success": success, "message": report})
