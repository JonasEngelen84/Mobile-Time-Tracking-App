from datetime import datetime, timedelta

DATETIME_FORMAT = "%d.%m.%Y %H:%M"

def stoppuhr_formatierung(diff: timedelta) -> str:
    """
    Formatiert ein Zeitintervall (timedelta) als 'HH:MM:SS'
    Beispiel: 1 Std 5 Min 7 Sek → '01:05:07'
    """
    sekunden = int(diff.total_seconds())
    stunden = sekunden // 3600
    minuten = (sekunden % 3600) // 60
    sek = sekunden % 60
    return f"{stunden:02}:{minuten:02}:{sek:02}"

def dauer_formatierung(sekunden: int) -> str:
    """
    Wandelt eine Dauer in Sekunden in ein lesbares Format: 'X Tage Y Stunden Z Minuten'.
    Einheiten mit Wert 0 werden übersprungen.
    Beispiel: 93784 Sek → '1 Tag 2 Stunden 3 Minuten'
    """
    minuten = sekunden // 60
    tage = minuten // (24 * 60)
    stunden = (minuten % (24 * 60)) // 60
    minuten = minuten % 60

    teile = []
    if tage: teile.append(f"{tage} Tag{'e' if tage != 1 else ''}")
    if stunden: teile.append(f"{stunden} Stunde{'n' if stunden != 1 else ''}")
    if minuten or not teile: teile.append(f"{minuten} Minute{'n' if minuten != 1 else ''}")

    return " ".join(teile)

def konvertiere_zeitformat(input_str: str) -> datetime | None:
    """
    Versucht, einen Zeitstring gemäß DATETIME_FORMAT in ein datetime-Objekt zu konvertieren.
    Gibt None zurück, wenn der String nicht dem erwarteten Format entspricht.
    """
    try:
        return datetime.strptime(input_str, DATETIME_FORMAT)
    except ValueError:
        return None
