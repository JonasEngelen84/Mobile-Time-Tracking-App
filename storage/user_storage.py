import sqlite3
from backend.interfaces.user_storage_interface import UserStorageInterface

class UserStorage(UserStorageInterface):
    """Verbindet sich mit der angegebenen SQLite-Datenbankdatei."""
    def __init__(self, db_file="zeiterfassung.db"):
        self.conn = sqlite3.connect(db_file)
        self._create_table()

    """Erstellt die Tabelle für Nutzer, falls sie nicht existiert."""
    def _create_table(self):        
        cursor = self.conn.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS nutzer (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                benutzername TEXT UNIQUE NOT NULL,
                passwort TEXT NOT NULL
            )
        """)
        self.conn.commit()

    """
        Speichert einen neuen Benutzer.
        Gibt True zurück, wenn erfolgreich, False wenn Benutzername bereits existiert.
        """
    def save_user(self, username: str, password: str) -> bool:        
        try:
            cursor = self.conn.cursor()
            cursor.execute("""
                INSERT INTO nutzer (benutzername, passwort)
                VALUES (?, ?)
            """, (username, password))
            self.conn.commit()
            return True
        except sqlite3.IntegrityError:
            # Benutzername existiert bereits
            return False

    """Überprüft, ob Benutzername und Passwort übereinstimmen."""
    def auth_user(self, username: str, password: str) -> bool:        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT id FROM nutzer WHERE benutzername = ? AND passwort = ?
        """, (username, password))
        return cursor.fetchone() is not None

    """
    Destruktor – wird aufgerufen, wenn das Objekt gelöscht wird.
    Schließt die Verbindung zur SQLite-Datenbank, um Speicher freizugeben
    und Datenbankressourcen sauber freizuschalten.
    """
    def __del__(self):
        self.conn.close()
