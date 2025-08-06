from abc import ABC, abstractmethod

class UserStorageInterface(ABC):
    """
    Abstraktes Interface für die Benutzerverwaltung.
    Definiert die benötigten Methoden, um Benutzer zu speichern und zu authentifizieren.
    Konkrete Implementierungen (z. B. SQLite, API, Datei) müssen diese Methoden bereitstellen.
    """

    """
    Speichert einen neuen Benutzer mit Benutzername und Passwort.
    Rückgabe:
        True bei erfolgreichem Speichern,
        False bei Fehler (z. B. Benutzer existiert bereits).
    """
    @abstractmethod
    def save_user(self, username: str, password: str) -> bool:
        pass


    """
    Überprüft, ob Benutzername und Passwort korrekt sind.
    Rückgabe:
        True bei erfolgreicher Authentifizierung,
        False bei ungültigen Zugangsdaten.
    """
    @abstractmethod
    def auth_user(self, username: str, password: str) -> bool:
        pass