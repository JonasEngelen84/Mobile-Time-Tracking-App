from storage.user_storage import UserStorage

user_storage = UserStorage()

def registrieren(benutzername: str, passwort: str, passwort_wiederholung: str) -> tuple[bool, str]:
    if not benutzername or not passwort or not passwort_wiederholung:
        return False, "Alle Felder müssen ausgefüllt werden."

    if passwort != passwort_wiederholung:
        return False, "Passwörter stimmen nicht überein."

    erfolg = user_storage.benutzer_speichern(benutzername, passwort)
    if erfolg:
        return True, "Registrierung erfolgreich."
    else:
        return False, "Registrierung fehlgeschlagen. Bitte später erneut versuchen."

def anmelden(benutzername: str, passwort: str) -> tuple[bool, str]:
    if not benutzername or not passwort:
        return False, "Benutzername und Passwort müssen ausgefüllt sein."
    
    authentifiziert = user_storage.benutzer_authentifizieren(benutzername, passwort)
    if authentifiziert:
        return True, "Login erfolgreich."
    else:
        return False, "Benutzername oder Passwort ist falsch."
