from storage.user_storage import UserStorage

user_storage = UserStorage()

def register(username: str, password: str, password_repetition: str, on_success: callable = None) -> tuple[bool, str]:
    """
    Führt die Benutzerregistrierung durch. Gibt ein Tupel (Erfolg, Nachricht) zurück.
    Optional: Callback `on_success`, der bei erfolgreicher Registrierung ausgeführt wird.
    """
    if not username or not password or not password_repetition:
        return False, "Alle Felder müssen ausgefüllt sein."

    if password != password_repetition:
        return False, "Passwörter stimmen nicht überein."

    success = user_storage.save_user(username, password)

    if success:
        if callable(on_success):
            on_success()
        return True, "Registrierung war erfolgreich."
    else:
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
    