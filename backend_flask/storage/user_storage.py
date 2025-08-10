import sqlite3
import bcrypt  # pip install bcrypt
from typing import Optional
from utils.db_connection_util import get_db_connection
from interfaces.user_storage_interface import UserStorageInterface


class UserStorage(UserStorageInterface):
    def __init__(self):
        self._create_table() # Initial einmalig Tabelle erstellen (eigene Connection pro Aufruf)

    # Erstellt die Tabelle `user`, falls sie noch nicht existiert.
    def _create_table(self) -> None:
        conn = get_db_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """
                CREATE TABLE IF NOT EXISTS user (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    username TEXT UNIQUE NOT NULL,
                    password TEXT NOT NULL
                )
                """
            )
            conn.commit()
        finally:
            conn.close()

    # Legt einen neuen Benutzer an (mit bcrypt-gehashtem Passwort).
    def save_user(self, username: str, password: str) -> bool:
        hashed_str = bcrypt.hashpw(
            password.encode("utf-8"), bcrypt.gensalt()
        ).decode("utf-8")

        conn = get_db_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                """
                INSERT INTO user (username, password)
                VALUES (?, ?)
                """,
                (username, hashed_str),
            )
            conn.commit()
            return True
        except sqlite3.IntegrityError:
            return False
        finally:
            conn.close()

    # Prüft, ob Benutzername und Passwort korrekt sind.
    def auth_user(self, username: str, password: str) -> bool:
        conn = get_db_connection()
        try:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT password FROM user WHERE username = ?",
                (username,),
            )
            row: Optional[tuple] = cursor.fetchone()
            if not row:
                return False  # Benutzer nicht vorhanden

            stored = row[0]  # str oder bytes möglich

            # Bytes für bcrypt vorbereiten
            if isinstance(stored, bytes):
                stored_bytes = stored
            else:
                stored_bytes = str(stored).encode("utf-8")

            # Moderner bcrypt-Hash
            if isinstance(stored, str) and stored.startswith("$2"):
                try:
                    return bcrypt.checkpw(password.encode("utf-8"), stored_bytes)
                except ValueError:
                    return False

            # Legacy-Fall: Klartext-Passwort in DB
            if stored == password:
                # Migration: Neues bcrypt-Hash speichern
                new_hash = bcrypt.hashpw(
                    password.encode("utf-8"), bcrypt.gensalt()
                ).decode("utf-8")
                cursor.execute(
                    "UPDATE user SET password = ? WHERE username = ?",
                    (new_hash, username),
                )
                conn.commit()
                return True

            return False
        finally:
            conn.close()
