from abc import ABC, abstractmethod

class UserStorageInterface(ABC):
    @abstractmethod
    def benutzer_speichern(self, benutzername: str, passwort: str) -> bool:
        pass

    @abstractmethod
    def benutzer_authentifizieren(self, benutzername: str, passwort: str) -> bool:
        pass