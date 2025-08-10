"""
Diese Datei kapselt die Erstellung und Verwaltung der SQLite-Datenbankverbindung.
"""

import sqlite3
from pathlib import Path

# Absoluter Pfad zur Datenbankdatei bestimmen
# Vorteil: Funktioniert auch, wenn das Skript von einem anderen Verzeichnis gestartet wird
# Die DB beim ersten Verbindungsaufbau automatisch erstellt, wenn sie noch nicht existiert.
BASE_DIR = Path(__file__).resolve().parent.parent  # -> backend_flask
DB_PATH = BASE_DIR / "time_tracking.db"

def get_db_connection() -> sqlite3.Connection:
    """
    Stellt eine Verbindung zur SQLite-Datenbank her.

    Returns:
        conn (sqlite3.Connection): Offene Verbindung zur Datenbank

    Wichtige Hinweise:
    - Die Verbindung sollte nach Benutzung IMMER mit conn.close() geschlossen werden.
    - row_factory erlaubt den Zugriff auf Spaltennamen statt nur Index.
    """
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn
