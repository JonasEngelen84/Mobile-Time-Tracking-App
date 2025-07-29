from datetime import datetime
from storage.time_storage import TimeStorage
from tkinter import messagebox
from logic.time_format_logic import duration_formatting, stopwatch_formatting, convert_time_format

# Konstante
DATETIME_FORMAT = "%d.%m.%Y %H:%M"

# Speicher-Instanz
time_storage = TimeStorage()

# Globale Zustände
start = None
activity = None
timer_running = [False]

"""Startet die Zeiterfassung mit der aktuellen Uhrzeit."""
def start_stopwatch(activity_name, timer_label, btn_manual):
    global start, activity
    start = datetime.now()
    activity = activity_name
    timer_running[0] = True

    btn_manual.config(state="disabled")
    timer_label.config(text="00:00:00", font=("Arial", 20, "bold"))

    print(f"🟢 Start: {activity} um {start.strftime(DATETIME_FORMAT)}")
    update_stopwatch(timer_label)

"""Stopt die Zeiterfassung und speichert den entry."""
def stop_stopwatch(timer_label, btn_manual, username):
    global start, activity

    if not start:
        print("⚠️ Keine aktive Stopuhr.")
        return

    timer_running[0] = False
    end = datetime.now()
    duration = end - start
    duration_text = duration_formatting(int(duration.total_seconds()))

    btn_manual.config(state="normal")
    timer_label.config(text=f"duration: {duration_text}", font=("Arial", 12, "bold"))

    duration_min = int(duration.total_seconds() // 60)
    entry = {
        "activitaet": activity,
        "start": start.isoformat(),
        "ende": end.isoformat(),
        "dauer_min": duration_min,
        "benutzer": username
    }
    time_storage.save(entry)

    print(f"🔴 Stop: {activity} – duration: {duration_text}")
    start = None

"""Aktualisiert die Zeit im Label jede Sekunde."""
def update_stopwatch(timer_label):
    
    if timer_running[0] and start:
        diff = datetime.now() - start
        timer_label.config(text=stopwatch_formatting(diff))
        timer_label.after(1000, lambda: update_stopwatch(timer_label))

"""Verarbeitet manuelle Eingabezeiten, prüft und speichert."""
def confirm_manual_entry(start_str: str, stop_str: str, activity: str, timer_label, username) -> str:
    start = convert_time_format(start_str)
    stop = convert_time_format(stop_str)

    if not start or not stop or stop <= start:
        timer_label.config(font=("Arial", 12))
        return "❌ Ungültige Eingabe"

    duration_s = int((stop - start).total_seconds())
    duration_text = duration_formatting(duration_s)

    if duration_s >= 86400:  # Mehr als 1 Tag
        timer_label.config(font=("Arial", 9, "bold"))
    elif duration_s >= 3600:  # Mehr als 1 Stunde
        timer_label.config(font=("Arial", 10, "bold"))
    else:
        timer_label.config(font=("Arial", 12, "bold"))

    entry = {        
        "activitaet": activity,
        "start": start.isoformat(),
        "ende": stop.isoformat(),
        "dauer_min": duration_s // 60,
        "benutzer": username
    }
    time_storage.save(entry)

    print(f"ℹ️ Manuelle Eingabe: {activity}, duration: {duration_text}")
    return f"duration: {duration_text}"

def show_overview():
        messagebox.showinfo("Übersicht", "In Bearbeitung.")
