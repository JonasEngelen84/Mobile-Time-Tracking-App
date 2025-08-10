from abc import ABC, abstractmethod

# Abstraktes Interface zur Speicherung von Zeiteinträgen.
class TimeStorageInterface(ABC):
    @abstractmethod
    def save(self, entry: dict):
        pass