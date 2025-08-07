from storage.user_storage import UserStorage

# Instanz der Datenbankschicht zur Speicherung und Abfrage von Benutzerdaten
user_storage = UserStorage()

def register(username: str, password: str, password_repetition: str, on_success: callable = None) -> tuple[bool, str]:
    """
    Registriert einen neuen Benutzer.- Tuple (bool, str): Erfolgsstatus (True/False),
    sowie eine Rückmeldung für den Benutzer.
    """

    # Validierung: Alle Felder müssen ausgefüllt sein
    if not username or not password or not password_repetition:
        return False, "Alle Felder müssen ausgefüllt sein."

    # Validierung: Passwort und Wiederholung müssen übereinstimmen
    if password != password_repetition:
        return False, "Passwörter stimmen nicht überein."

    # Benutzer speichern – false, wenn Benutzername bereits existiert
    success = user_storage.save_user(username, password)

    if success:
        # Optionalen Callback ausführen, z. B. Logging
        if callable(on_success):
            on_success()
        return True, "Registrierung war erfolgreich."
    else:
        # Benutzername existiert bereits
        return False, "Benutzername bereits vergeben."


def login(username: str, password: str, on_success: callable = None) -> tuple[bool, str]:
    """
    Führt die Benutzeranmeldung durch. Gibt ein Tupel (Erfolg, Nachricht) zurück.
    Optional: Callback `on_success`, der bei erfolgreichem Login ausgeführt wird.
    """
    if not username or not password:
        return False, "Benutzername und Passwort müssen ausgefüllt sein."

    authenticated = user_storage.auth_user(username, password)

    if authenticated:
        if callable(on_success):
            on_success(username)
        return True, "Login war erfolgreich."
    else:
        return False, "Benutzername oder Passwort ist falsch."
    