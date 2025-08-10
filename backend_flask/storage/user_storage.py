import sqlite3
from interfaces.user_storage_interface import UserStorageInterface
import bcrypt  # pip install bcrypt
from typing import Optional
from backend_flask.utils.db_connection_util import get_db_connection


class UserStorage(UserStorageInterface):

    # Öffnet die Verbindung über die zentrale DB-Helper-Funktion
    def __init__(self):
        self.conn = get_db_connection()
        self._create_table()

    # Erstellt die Tabelle `nutzer`, falls sie noch nicht existiert
    def _create_table(self) -> None:
        cursor = self.conn.cursor()
        cursor.execute(
            """
            CREATE TABLE IF NOT EXISTS nutzer (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                benutzername TEXT UNIQUE NOT NULL,
                passwort TEXT NOT NULL
            )
            """
        )
        self.conn.commit()

    # Speichert einen neuen Benutzer
    def save_user(self, username: str, password: str) -> bool:
        """
        Vor dem Einfügen wird das Passwort mit bcrypt gehasht.

        Rückgabewerte:
        - True  : Benutzer wurde erfolgreich angelegt.
        - False : Benutzername existiert bereits (IntegrityError).
        """
        try:
            hashed_str = bcrypt.hashpw(
                password.encode("utf-8"), bcrypt.gensalt()
            ).decode("utf-8")

            cursor = self.conn.cursor()
            cursor.execute(
                """
                INSERT INTO nutzer (benutzername, passwort)
                VALUES (?, ?)
                """,
                (username, hashed_str),
            )
            self.conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False

    # Überprüft, ob Benutzername und Passwort übereinstimmen
    def auth_user(self, username: str, password: str) -> bool:
        cursor = self.conn.cursor()
        cursor.execute(
            "SELECT passwort FROM nutzer WHERE benutzername = ?",
            (username,),
        )
        row: Optional[tuple] = cursor.fetchone()
        if not row:
            # Benutzer nicht vorhanden
            return False

        stored = row[0]  # kann str oder bytes sein (je nach DB)

        # Wir brauchen bytes für bcrypt.checkpw
        if isinstance(stored, bytes):
            stored_bytes = stored
        else:
            stored_bytes = str(stored).encode("utf-8")

        # Ein bcrypt-Hash beginnt typischerweise mit "$2a$" / "$2b$" / "$2y$"
        if isinstance(stored, str) and stored.startswith("$2"):
            # moderner Hash-Fall
            try:
                return bcrypt.checkpw(password.encode("utf-8"), stored_bytes)
            except ValueError:
                # Ungültiges Hash-Format
                return False
        else:
            # Legacy: gespeichertes Passwort steht im Klartext.
            if stored == password:
                # Migration: Klartext akzeptiert -> neuen Hash speichern
                new_hash = bcrypt.hashpw(
                    password.encode("utf-8"), bcrypt.gensalt()
                ).decode("utf-8")
                cursor.execute(
                    "UPDATE nutzer SET passwort = ? WHERE benutzername = ?",
                    (new_hash, username),
                )
                self.conn.commit()
                return True
            else:
                return False

    # schließt die DB-Connection
    def __del__(self):
        try:
            self.conn.close()
        except Exception:
            pass
