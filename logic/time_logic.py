from datetime import datetime
from storage.time_storage import TimeStorage
from logic.format_logic import dauer_formatierung, stoppuhr_formatierung, konvertiere_zeitformat

# Konstante
DATETIME_FORMAT = "%d.%m.%Y %H:%M"

# Speicher-Inst anz
time_storage = TimeStorage()

# Globale Zustände
startzeit = None
aktivitaet = None
timer_laeuft = [False]

def start_stoppuhr(aktivitaet_name, timer_label, btn_manuell):
    """
    Startet die Zeiterfassung mit der aktuellen Uhrzeit.
    """
    global startzeit, aktivitaet
    startzeit = datetime.now()
    aktivitaet = aktivitaet_name
    timer_laeuft[0] = True

    btn_manuell.config(state="disabled")
    timer_label.config(text="00:00:00", font=("Arial", 20, "bold"))

    print(f"🟢 Start: {aktivitaet} um {startzeit.strftime(DATETIME_FORMAT)}")
    update_stoppuhr(timer_label)

def stopp_stoppuhr(timer_label, btn_manuell, benutzername):
    """
    Stoppt die Zeiterfassung und speichert den Eintrag.
    """
    global startzeit, aktivitaet

    if not startzeit:
        print("⚠️ Keine aktive Stoppuhr.")
        return

    timer_laeuft[0] = False
    ende = datetime.now()
    dauer = ende - startzeit
    dauer_text = dauer_formatierung(int(dauer.total_seconds()))

    btn_manuell.config(state="normal")
    timer_label.config(text=f"Dauer: {dauer_text}", font=("Arial", 12, "bold"))

    dauer_min = int(dauer.total_seconds() // 60)
    eintrag = {
        "aktivitaet": aktivitaet,
        "start": startzeit.isoformat(),
        "ende": ende.isoformat(),
        "dauer_min": dauer_min,
        "benutzer": benutzername
    }
    time_storage.speichern(eintrag)

    print(f"🔴 Stopp: {aktivitaet} – Dauer: {dauer_text}")
    startzeit = None

def update_stoppuhr(timer_label):
    """
    Aktualisiert die Zeit im Label jede Sekunde.
    """
    if timer_laeuft[0] and startzeit:
        diff = datetime.now() - startzeit
        timer_label.config(text=stoppuhr_formatierung(diff))
        timer_label.after(1000, lambda: update_stoppuhr(timer_label))

def manuelle_eingaben_bestätigung(start_str: str, stopp_str: str, aktivitaet: str, timer_label, benutzername) -> str:
    """
    Verarbeitet manuelle Eingabezeiten, prüft und speichert.
    """
    start = konvertiere_zeitformat(start_str)
    stopp = konvertiere_zeitformat(stopp_str)

    if not start or not stopp or stopp <= start:
        timer_label.config(font=("Arial", 12))
        return "❌ Ungültige Eingabe"

    dauer_s = int((stopp - start).total_seconds())
    dauer_text = dauer_formatierung(dauer_s)

    if dauer_s >= 86400:  # Mehr als 1 Tag
        timer_label.config(font=("Arial", 9, "bold"))
    elif dauer_s >= 3600:  # Mehr als 1 Stunde
        timer_label.config(font=("Arial", 10, "bold"))
    else:
        timer_label.config(font=("Arial", 12, "bold"))

    eintrag = {        
        "aktivitaet": aktivitaet,
        "start": start.isoformat(),
        "ende": stopp.isoformat(),
        "dauer_min": dauer_s // 60,
        "benutzer": benutzername
    }
    time_storage.speichern(eintrag)

    print(f"ℹ️ Manuelle Eingabe: {aktivitaet}, Dauer: {dauer_text}")
    return f"Dauer: {dauer_text}"
