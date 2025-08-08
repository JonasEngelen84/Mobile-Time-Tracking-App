from datetime import datetime
from storage.time_storage import TimeStorage
from tkinter import messagebox
from backend_flask.utils.time_format_utils import duration_formatting, stopwatch_formatting, convert_time_format

# Konstante für das Datums- und Zeitformat
DATETIME_FORMAT = "%d.%m.%Y %H:%M"

# Instanz des Speichers für Zeit-Einträge
time_storage = TimeStorage()

# Globale Zustände zur Steuerung der Stopuhr
start = None           # Startzeitpunkt der aktuellen Zeiterfassung
activity = None        # Name der aktuellen Aktivität
timer_running = [False]  # Flag, ob die Stoppuhr läuft (in Liste für Mutable)

def start_stopwatch(activity_name, timer_label, btn_manual):
    """
    Startet die Zeiterfassung mit der aktuellen Uhrzeit.
    Aktiviert die Stopuhr und aktualisiert das UI entsprechend.
    """
    global start, activity
    start = datetime.now()
    activity = activity_name
    timer_running[0] = True

    btn_manual.config(state="disabled")  # Manuelle Eingabe während Stoppuhr deaktivieren
    timer_label.config(text="00:00:00", font=("Arial", 20, "bold"))  # Anzeige zurücksetzen

    print(f"🟢 Start: {activity} um {start.strftime(DATETIME_FORMAT)}")
    update_stopwatch(timer_label)  # Startet die UI-Aktualisierung der Laufzeit

def stop_stopwatch(timer_label, btn_manual, username):
    """
    Stoppt die laufende Zeiterfassung, berechnet Dauer und speichert den Eintrag.
    Aktualisiert UI und ermöglicht manuelle Eingabe wieder.
    """
    global start, activity

    if not start:
        print("⚠️ Keine aktive Stopuhr.")
        return

    timer_running[0] = False
    end = datetime.now()
    duration = end - start
    duration_text = duration_formatting(int(duration.total_seconds()))

    btn_manual.config(state="normal")  # Manuelle Eingabe wieder erlauben
    timer_label.config(text=f"dauer: {duration_text}", font=("Arial", 12, "bold"))

    duration_min = int(duration.total_seconds() // 60)
    entry = {
        "aktivitaet": activity,
        "start": start.isoformat(),
        "ende": end.isoformat(),
        "dauer_min": duration_min,
        "benutzer": username
    }
    time_storage.save(entry)  # Speichert den Eintrag persistierend

    print(f"🔴 Stop: {activity} – dauer: {duration_text}")
    start = None  # Stopuhr zurücksetzen

def update_stopwatch(timer_label):
    """
    Aktualisiert die Anzeige der laufenden Zeit im Timer-Label jede Sekunde.
    Solange die Stoppuhr läuft, wird die Anzeige neu gesetzt.
    """
    if timer_running[0] and start:
        diff = datetime.now() - start
        timer_label.config(text=stopwatch_formatting(diff))
        # Wiederholt sich alle 1000 ms (1 Sekunde)
        timer_label.after(1000, lambda: update_stopwatch(timer_label))

def confirm_manual_entry(start_str: str, stop_str: str, activity: str, timer_label, username) -> str:
    """
    Verarbeitet manuelle Eingaben von Start- und Stoppzeit.
    Prüft Validität, berechnet Dauer, speichert den Eintrag und aktualisiert UI.
    Gibt Statusmeldung als String zurück.
    """
    start = convert_time_format(start_str)
    stop = convert_time_format(stop_str)

    # Validierung der Eingabezeiten
    if not start or not stop or stop <= start:
        timer_label.config(font=("Arial", 12))
        return "❌ Ungültige Eingabe"

    duration_s = int((stop - start).total_seconds())
    duration_text = duration_formatting(duration_s)

    # Schriftgröße an Dauer anpassen
    if duration_s >= 86400:  # Mehr als 1 Tag
        timer_label.config(font=("Arial", 9, "bold"))
    elif duration_s >= 3600:  # Mehr als 1 Stunde
        timer_label.config(font=("Arial", 10, "bold"))
    else:
        timer_label.config(font=("Arial", 12, "bold"))

    entry = {
        "aktivitaet": activity,
        "start": start.isoformat(),
        "ende": stop.isoformat(),
        "dauer_min": duration_s // 60,
        "benutzer": username
    }
    time_storage.save(entry)

    print(f"ℹ️ Manuelle Eingabe: {activity}, dauer: {duration_text}")
    return f"dauer: {duration_text}"

def show_overview():
    """
    Platzhalter für die Übersicht-Funktionalität.
    Zeigt eine einfache Info-Box an.
    """
    messagebox.showinfo("Übersicht", "In Bearbeitung.")
