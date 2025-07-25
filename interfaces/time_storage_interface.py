from abc import ABC, abstractmethod

class TimeStorageInterface(ABC):
    @abstractmethod
    def speichern(self, eintrag: dict):
        pass