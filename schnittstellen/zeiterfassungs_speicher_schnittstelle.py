from abc import ABC, abstractmethod

class TimeStorageInterface(ABC):
    """
    Abstraktes Interface zur Speicherung von Zeiteinträgen.
    Dieses Interface stellt sicher, dass jede konkrete Implementierung
    (z.B. SQLite, Datei, REST-API) eine Methode zur Speicherung bereitstellt.
    """

    """
        Speichert einen einzelnen Zeiteintrag.

        Parameter:
            eintrag (dict): Ein Dictionary mit folgenden typischen Feldern:
                - 'aktivitaet': Beschreibung der Tätigkeit
                - 'start': Startzeitpunkt (als String oder datetime)
                - 'ende': Endzeitpunkt (als String oder datetime)
                - 'dauer_min': Dauer in Minuten
                - 'benutzer': Benutzername oder ID

        Rückgabe:
            Kann je nach Implementierung ein Bestätigungswert oder nichts zurückgeben.
        """
    @abstractmethod
    def speichern(self, eintrag: dict):
        pass