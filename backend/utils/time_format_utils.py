from datetime import datetime, timedelta

DATETIME_FORMAT = "%d.%m.%Y %H:%M"

def stopwatch_formatting(diff: timedelta) -> str:
    """
    Formatiert ein Zeitintervall (timedelta) als 'HH:MM:SS'
    Beispiel: 1 Std 5 Min 7 sec → '01:05:07'
    """
    seconds = int(diff.total_seconds())
    hours = seconds // 3600
    minutes = (seconds % 3600) // 60
    sec = seconds % 60
    return f"{hours:02}:{minutes:02}:{sec:02}"

def duration_formatting(seconds: int) -> str:
    """
    Wandelt eine Dauer in seconds in ein lesbares Format: 'X days Y hours Z minutes'.
    Einheiten mit Wert 0 werden übersprungen.
    Beispiel: 93784 sec → '1 Tag 2 hours 3 minutes'
    """
    minutes = seconds // 60
    days = minutes // (24 * 60)
    hours = (minutes % (24 * 60)) // 60
    minutes = minutes % 60

    parts = []
    if days: parts.append(f"{days} Tag{'e' if days != 1 else ''}")
    if hours: parts.append(f"{hours} Stunde{'n' if hours != 1 else ''}")
    if minutes or not parts: parts.append(f"{minutes} Minute{'n' if minutes != 1 else ''}")

    return " ".join(parts)

def convert_time_format(input_str: str) -> datetime | None:
    """
    Versucht, einen Zeitstring gemäß DATETIME_FORMAT in ein datetime-Objekt zu konvertieren.
    Gibt None zurück, wenn der String nicht dem erwarteten Format entspricht.
    """
    try:
        return datetime.strptime(input_str, DATETIME_FORMAT)
    except ValueError:
        return None
