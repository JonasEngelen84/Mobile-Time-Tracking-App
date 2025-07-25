import sqlite3
from interfaces.time_storage_interface import TimeStorageInterface

class TimeStorage(TimeStorageInterface):
    def __init__(self, db_datei="zeiterfassung.db"):
        self.conn = sqlite3.connect(db_datei)
        self._erstelle_tabelle()

    def _erstelle_tabelle(self):
        """Erstellt die Tabelle für Zeiterfassungen, falls sie nicht existiert."""
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

    def speichern(self, eintrag: dict):
        """Speichert einen Zeiteintrag."""
        cursor = self.conn.cursor()
        cursor.execute("""
            INSERT INTO zeiterfassung (aktivitaet, start, ende, dauer_min, benutzer) 
            VALUES (?, ?, ?, ?, ?)
        """, (
            eintrag["aktivitaet"],
            eintrag["start"],
            eintrag["ende"],
            eintrag["dauer_min"],
            eintrag["benutzer"]
        ))
        self.conn.commit()

    def __del__(self):
        self.conn.close()
