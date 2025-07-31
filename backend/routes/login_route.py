from flask import Flask, request, jsonify
from services.auth_commands.auth_commands import login as login_logic  # Alias vergeben

app = Flask(__name__)

""" REST-API """
@app.route("/login", methods=["POST"])
def login_route():
    data = request.json
    user = data.get("user")
    password = data.get("password")

    success, report = login_logic(user, password)
    return jsonify({"success": success, "message": report})

if __name__ == "__main__":
    app.run(debug=True, port=5000)
