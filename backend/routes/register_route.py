from flask import Flask, request, jsonify
from services.auth_commands.auth_commands import register

app = Flask(__name__)

""" REST-API """
@app.route("/register", methods=["POST"])
def register():
    data = request.json
    user = data.get("user")
    password = data.get("password")
    password_repeat = data.get("password_repeat")

    success, report = register(user, password, password_repeat)
    return jsonify({"success": success, "message": report})

if __name__ == "__main__":
    app.run(debug=True, port=5000)
