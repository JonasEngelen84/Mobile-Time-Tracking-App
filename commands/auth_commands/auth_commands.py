from storage.user_storage import UserStorage
from tkinter import messagebox

user_storage = UserStorage()

def register(username: str, password: str, password_repetition: str, on_success: callable = None) -> None:
    """
    Führt eine Benutzerregistrierung durch und gibt direkt Rückmeldung via GUI.
    Optionaler Callback `on_success` wird bei successreicher Registrierung aufgerufen.
    """
    if not username or not password or not password_repetition:
        messagebox.showerror("Registrierung fehlgeschlagen", "Alle Felder müssen ausgefüllt werden.")
        return

    if password != password_repetition:
        messagebox.showerror("Registrierung fehlgeschlagen", "Passwörter stimmen nicht überein.")
        return

    success = user_storage.save_user(username, password)

    if success:
        messagebox.showinfo("Registrierung erfolgreich", "Die Registrierung wurde erfolgreich beendet.")
        if on_success:
            on_success()
    else:
        messagebox.showerror("Benutzername vergeben", "Bitte anderen Namen eingeben.")

def login(username: str, password: str, on_success=None) -> None:
    """
    Führt die Benutzeranmeldung durch.
    Zeigt bei Fehlern eine Messagebox an.
    Führt bei success den optionalen Callback `on_success` aus.
    """
    if not username or not password:
        messagebox.showerror("Login fehlgeschlagen", "Benutzername und Passwort müssen ausgefüllt sein.")
        return

    authenticated = user_storage.auth_user(username, password)

    if authenticated:
        if callable(on_success):
            on_success(username)
            return True, ""
    else:
        messagebox.showerror("Login fehlgeschlagen", "Benutzername oder Passwort ist falsch.")
    