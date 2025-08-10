from backend_flask.utils.db_connection_util import get_db_connection
from interfaces.time_storage_interface import TimeStorageInterface

class TimeStorage(TimeStorageInterface):

    # Öffnet die Verbindung über die zentrale DB-Helper-Funktion
    def __init__(self):
        self.conn = get_db_connection()
        self._create_table()

    # Erstellt die Tabelle für Zeiterfassungen, falls sie nicht existiert
    def _create_table(self):        
        cursor = self.conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS zeiterfassung (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                aktivitaet TEXT NOT NULL,
                start TEXT NOT NULL,
                ende TEXT NOT NULL,
                dauer_min INTEGER NOT NULL
            )
        """)
        self.conn.commit()

    # Speichert einen Zeiteintrag
    def save(self, entry: dict):        
        cursor = self.conn.cursor()
        cursor.execute("""
            INSERT INTO zeiterfassung (aktivitaet, start, ende, dauer_min, benutzer) 
            VALUES (?, ?, ?, ?, ?)
        """, (
            entry["aktivitaet"],
            entry["start"],
            entry["ende"],
            entry["dauer_min"],
            entry["benutzer"]
        ))
        self.conn.commit()

    # schließt die DB-Connection
    def __del__(self):
        try:
            self.conn.close()
        except Exception:
            pass
