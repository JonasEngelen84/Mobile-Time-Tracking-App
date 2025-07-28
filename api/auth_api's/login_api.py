from flask import Flask, request, jsonify
from commands.auth_commands.auth_commands import login

app = Flask(__name__)

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    user = data.get("user")
    password = data.get("password")

    success, report = login(user, password)
    return jsonify({"success": success, "message": report})

if __name__ == "__main__":
    app.run(debug=True, port=5000)
