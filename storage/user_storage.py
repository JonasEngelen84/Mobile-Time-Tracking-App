import sqlite3
from interfaces.user_storage_interface import UserStorageInterface

class UserStorage(UserStorageInterface):
    def __init__(self, db_datei="zeiterfassung.db"):
        self.conn = sqlite3.connect(db_datei)
        self._erstelle_tabelle()

    def _erstelle_tabelle(self):
        """Erstellt die Tabelle für Nutzer, falls sie nicht existiert."""
        cursor = self.conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS nutzer (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                benutzername TEXT UNIQUE NOT NULL,
                passwort TEXT NOT NULL
            )
        """)
        self.conn.commit()

    def benutzer_speichern(self, benutzername: str, passwort: str) -> bool:
        """
        Speichert einen neuen Benutzer.
        Gibt True zurück, wenn erfolgreich, False wenn Benutzername bereits existiert.
        """
        try:
            cursor = self.conn.cursor()
            cursor.execute("""
                INSERT INTO nutzer (benutzername, passwort)
                VALUES (?, ?)
            """, (benutzername, passwort))
            self.conn.commit()
            return True
        except sqlite3.IntegrityError:
            # Benutzername existiert bereits
            return False

    def benutzer_authentifizieren(self, benutzername: str, passwort: str) -> bool:
        """Überprüft, ob Benutzername und Passwort übereinstimmen."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT id FROM nutzer WHERE benutzername = ? AND passwort = ?
        """, (benutzername, passwort))
        return cursor.fetchone() is not None

    def __del__(self):
        self.conn.close()

