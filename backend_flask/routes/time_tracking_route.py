from flask import Blueprint, request, jsonify
from services import time_services

time_tracking_blueprint = Blueprint("time_tracking", __name__)

@time_tracking_blueprint.route("/start_timer", methods=["POST"])
def start_timer_route():
    """
    Startet die Zeiterfassung.
    Erwartet JSON mit "username" und "activity".
    Ruft die Logik in time_services auf und gibt Erfolg/Fehler zurück.
    """
    data = request.json
    username = data.get("username")
    activity = data.get("activity")

    if not username or not activity:
        return jsonify({"success": False, "message": "Benutzername und Aktivität sind erforderlich."}), 400

    # Startzeit in time_services setzen (UI-relevante Updates hier nicht möglich)
    # Statt UI-Elemente (timer_label, btn_manual) einfach intern speichern oder Status zurückgeben.
    # Da du Tkinter-Elemente hast, ist hier eher Backend-Only Logik sinnvoll.

    # Einfacher Startzeitpunkt speichern, ohne UI (für API-Logik)
    time_services.start = None  # ggf. zurücksetzen
    time_services.activity = None
    time_services.timer_running = [False]

    # Setze Startzeit + Activity
    from datetime import datetime
    time_services.start = datetime.now()
    time_services.activity = activity
    time_services.timer_running[0] = True

    return jsonify({"success": True, "message": f"Zeiterfassung für '{activity}' gestartet."})

@time_tracking_blueprint.route("/stop_timer", methods=["POST"])
def stop_timer_route():
    """
    Stoppt die Zeiterfassung.
    Erwartet JSON mit "username".
    Berechnet Dauer, speichert Eintrag über time_services und gibt Ergebnis zurück.
    """
    data = request.json
    username = data.get("username")

    if not username:
        return jsonify({"success": False, "message": "Benutzername ist erforderlich."}), 400

    if not time_services.start:
        return jsonify({"success": False, "message": "Keine aktive Zeiterfassung zum Stoppen."}), 400

    from datetime import datetime
    end = datetime.now()
    duration = end - time_services.start

    # Dauer formatieren
    from backend_flask.utils.time_format_utils import duration_formatting
    duration_text = duration_formatting(int(duration.total_seconds()))

    # Speichere den Eintrag
    duration_min = int(duration.total_seconds() // 60)
    entry = {
        "aktivitaet": time_services.activity,
        "start": time_services.start.isoformat(),
        "ende": end.isoformat(),
        "dauer_min": duration_min,
        "benutzer": username
    }
    time_services.time_storage.save(entry)

    # Reset Timer
    time_services.start = None
    time_services.activity = None
    time_services.timer_running[0] = False

    return jsonify({"success": True, "message": f"Zeiterfassung gestoppt, Dauer: {duration_text}."})

@time_tracking_blueprint.route("/manual_entry", methods=["POST"])
def manual_entry_route():
    """
    Verarbeitet manuelle Zeit-Einträge.
    Erwartet JSON mit "username", "activity", "start", "stop".
    Validiert Zeiten, speichert Eintrag, gibt Status zurück.
    """
    data = request.json
    username = data.get("username")
    activity = data.get("activity")
    start_str = data.get("start")
    stop_str = data.get("stop")

    if not all([username, activity, start_str, stop_str]):
        return jsonify({"success": False, "message": "Alle Felder (Benutzer, Aktivität, Start, Stopp) sind erforderlich."}), 400

    # Nutze die Funktion aus time_services (passt UI-Elemente einfach weg)
    from backend_flask.utils.time_format_utils import convert_time_format, duration_formatting

    start = convert_time_format(start_str)
    stop = convert_time_format(stop_str)

    if not start or not stop or stop <= start:
        return jsonify({"success": False, "message": "Ungültige Start- oder Stoppzeit."}), 400

    duration_s = int((stop - start).total_seconds())
    duration_text = duration_formatting(duration_s)

    entry = {
        "aktivitaet": activity,
        "start": start.isoformat(),
        "ende": stop.isoformat(),
        "dauer_min": duration_s // 60,
        "benutzer": username
    }
    time_services.time_storage.save(entry)

    return jsonify({"success": True, "message": f"Manuelle Eingabe gespeichert, Dauer: {duration_text}."})
