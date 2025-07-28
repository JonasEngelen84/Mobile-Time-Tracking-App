import sqlite3
from interfaces.time_storage_interface import TimeStorageInterface

class TimeStorage(TimeStorageInterface):
    """Verbindet sich mit der angegebenen SQLite-Datenbankdatei."""
    def __init__(self, db_file="zeiterfassung.db"):
        self.conn = sqlite3.connect(db_file)
        self._create_table()

    """Erstellt die Tabelle für Zeiterfassungen, falls sie nicht existiert."""
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

    """Speichert einen Zeiteintrag."""
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

    """
    Destruktor – wird aufgerufen, wenn das Objekt gelöscht wird.

    Schließt die Verbindung zur SQLite-Datenbank, um Speicher freizugeben
    und Datenbankressourcen sauber freizuschalten.
    """
    def __del__(self):
        self.conn.close()
