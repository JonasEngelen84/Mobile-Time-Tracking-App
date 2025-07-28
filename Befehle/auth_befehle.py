from speicher.benutzer_speicher import UserStorage
from tkinter import messagebox

user_storage = UserStorage()

def registrieren(benutzername: str, passwort: str, passwort_wiederholung: str, on_success: callable = None) -> None:
    """
    Führt eine Benutzerregistrierung durch und gibt direkt Rückmeldung via GUI.
    Optionaler Callback `on_success` wird bei erfolgreicher Registrierung aufgerufen.
    """
    if not benutzername or not passwort or not passwort_wiederholung:
        messagebox.showerror("Fehler", "Alle Felder müssen ausgefüllt werden.")
        return

    if passwort != passwort_wiederholung:
        messagebox.showerror("Fehler", "Passwörter stimmen nicht überein.")
        return

    erfolg = user_storage.benutzer_speichern(benutzername, passwort)

    if erfolg:
        messagebox.showinfo("Erfolg", "Registrierung erfolgreich.")
        if on_success:
            on_success()
    else:
        messagebox.showerror("Benutzername vergeben", "Bitte anderen Namen eingeben.")

def anmelden(benutzername: str, passwort: str, on_success=None) -> None:
    """
    Führt die Benutzeranmeldung durch.
    Zeigt bei Fehlern eine Messagebox an.
    Führt bei Erfolg den optionalen Callback `on_success` aus.
    """
    if not benutzername or not passwort:
        messagebox.showerror("Fehler", "Benutzername und Passwort müssen ausgefüllt sein.")
        return

    authentifiziert = user_storage.benutzer_authentifizieren(benutzername, passwort)

    if authentifiziert:
        if callable(on_success):
            on_success(benutzername)
    else:
        messagebox.showerror("Login fehlgeschlagen", "Benutzername oder Passwort ist falsch.")
    if authentifiziert:
        return True, ""
    else:
        return False, "Benutzername oder Passwort ist falsch."
