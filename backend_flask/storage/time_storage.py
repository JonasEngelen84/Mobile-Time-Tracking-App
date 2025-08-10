"""
TimeStorage
-----------
Diese Klasse implementiert die TimeStorageInterface und kümmert sich um die
Speicherung und Verwaltung von Zeiterfassungs-Daten in der SQLite-Datenbank.
"""

from utils.db_connection_util import get_db_connection
from interfaces.time_storage_interface import TimeStorageInterface

class TimeStorage(TimeStorageInterface):
    def __init__(self):
        self._create_table() # Initial einmalig Tabelle erstellen (eigene Connection pro Aufruf)

    # Erstellt die Tabelle 'time_tracking' falls nicht vorhanden.
    def _create_table(self):
        conn = get_db_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS time_tracking (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    user TEXT NOT NULL,
                    activity TEXT NOT NULL,
                    start TEXT NOT NULL,
                    end TEXT NOT NULL,
                    duration_min INTEGER NOT NULL
                )
                """
            )
            conn.commit()
        finally:
            conn.close()

    # Speichert einen Zeiteintrag in der Datenbank.
    def save(self, entry: dict):
        conn = get_db_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
            """
            INSERT INTO time_tracking (user, activity, start, end, duration_min) 
            VALUES (?, ?, ?, ?, ?)
            """, (
                entry["user"],
                entry["activity"],
                entry["start"],
                entry["end"],
                entry["duration_min"]
            ))
            conn.commit()
        finally:
            conn.close()
