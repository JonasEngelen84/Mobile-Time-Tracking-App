from flask import Flask, request, jsonify
from Befehle.auth_befehle import anmelden, registrieren

app = Flask(__name__)

@app.route("/login", methods=["POST"])
def login():
    daten = request.json
    benutzer = daten.get("benutzer")
    passwort = daten.get("passwort")

    erfolg, meldung = anmelden(benutzer, passwort)
    return jsonify({"success": erfolg, "message": meldung})


@app.route("/register", methods=["POST"])
def registrieren():
    daten = request.json
    benutzer = daten.get("benutzer")
    passwort = daten.get("passwort")
    passwort_wdh = daten.get("passwort_wdh")

    erfolg, meldung = registrieren(benutzer, passwort, passwort_wdh)
    return jsonify({"success": erfolg, "message": meldung})


if __name__ == "__main__":
    app.run(debug=True, port=5000)