from flask import Flask, request, jsonify
from commands.auth_commands.auth_commands import register

app = Flask(__name__)

@app.route("/register", methods=["POST"])
def register():
    data = request.json
    user = data.get("user")
    password = data.get("password")
    password_wdh = data.get("password_wdh")

    success, report = register(user, password, password_wdh)
    return jsonify({"success": success, "message": report})

if __name__ == "__main__":
    app.run(debug=True, port=5000)
