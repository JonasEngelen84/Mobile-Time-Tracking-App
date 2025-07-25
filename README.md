```
Mobile Zeiterfassungs-App (Mockup)

✨ Projektbeschreibung
Dieses Projekt ist eine modulare Desktop-Anwendung zur Erfassung, Speicherung und Verwaltung von Arbeitszeiten.
Ziel ist es, eine einfache, lokale Zeiterfassungslösung zu bieten, die ohne externe Abhängigkeiten auskommt
und sowohl Stoppuhr-basiertes Tracking als auch manuelle Eingaben unterstützt.
Die Anwendung trennt bewusst Benutzerverwaltung, Zeitlogik, Formatierung und Datenspeicherung
in klar strukturierte Module nach dem Prinzip "Separation of Concerns".
```
```
🔧 Technologien
•	Python 3.10+ -- Sprache
•	SQlite -- Relationale Datenbank für lokale persistente Speicherung
•	Tkinter – Frontend
•	Datetime – Zeithandling
•	abc-Modul – Abstract Base Classes (Interfaces) für testbare Architektur
•	Modulares Design -- Trennung von Business-Logik, Storage, Interfaces und Formatierung zur Wartbarkeit
```
```
🔍 Features
•	Benutzerregistrierung und Login (lokal, SQLite)
•	Aktionsauswahl per Drop Down
•	Zeittracking via Start/Stopp-Stoppuhr
•	Manuelle Eingabe von Arbeitszeiten
•	Einheitliche Zeitformatierung (z. B. „2 Stunden 30 Minuten“)
•	Datenpersistenz in SQLite
•	Erweiterbar durch Interface-basierte Architektur
```
```
🚧 Geplante Erweiterungen
Die aktuelle Version stellt ein funktionales MVP (Minimum Viable Product) dar.
Für die nächste Ausbaustufe sind folgende Erweiterungen geplant:
•	Übersicht bereits erfasster Zeiten
•	Export der erfassten Zeiten als Stundennachweis (PDF)
•	Anbindung an bestehende Datenbankstruktur
•	Transportverschlüsselung (HTTPS)
•	Passwort-Hashing
•	GUI-Verbesserung
•	Unit Tests & CI/CD-Pipeline
```
```
📂 Project Struktur
zeiterfassung/
├── interfaces/
│   ├── time_storage_interface.py    # Abstraktes Interface für Zeiteintrags-Speicherung
│   └── user_storage_interface.py    # Abstraktes Interface für Benutzerverwaltung
│
├── logic/
│   ├── auth_logic.py    # Implementierung der UserStorage mit SQLite (Login, Registrierung)
│   ├── format_logic.py  # Hilfsfunktionen zur Zeitformatierung & Validierung
│   └── time_logic.py    # Kernlogik: Start/Stopp der Zeiterfassung, manuelle Eingaben
│
├── storage/
│   ├── time_storage.py  # SQLite-basierte Speicherung der Zeiteinträge
│   └── user_storage.py  # SQLite-basierte Speicherung der Benutzereinträge
│
├── views/
│   ├── login_view.py    # GUI-Logik der Login-Maske
│   ├── main_view.py     # GUI-Logik der Zeiterfassungs-Maske
│   └── register_view.py # GUI-Logik der Register-Maske
│
├── LICENSE.txt          # Lizenz
├── main.py              # Einstiegspunkt - initialisiert die GUI sowie die zentrale Ablaufsteuerung.
├── README.md            # Projektdokumentation (diese Datei)
└── zeiterfassung.db     # SQLite-Datenbank (wird automatisch erstellt)
```
```
📄 Datenbankstruktur – SQLite
Die Anwendung verwendet eine SQLite-Datenbank (zeiterfassung.db) mit zwei zentralen Tabellen:

1. Tabelle: nutzer
   Speichert Benutzerkonten zur Authentifizierung.
   •	id
   •	benutzername
   •	passwort

2. Tabelle: zeiterfassung
   Speichert alle erfassten Arbeitszeit-Einträge.
   •	Id
   •	aktivitaet
   •	start
   •	ende
   •	dauer\_min
   •	benutzer

(Die Datenbank wird beim ersten Start automatisch erzeugt, wenn sie noch nicht existiert)
```
```
🧾 Zusätzliche Themen

1. Sichere Übermittlung der Daten:
   Um Man-in-the-Middle-Angriffe und/oder Sniffing zu verhindern ist für jegliche Kommunikation zwischen Front-/ und Backend ist HTTPS (SSL/TLS) ist zwingend erforderlich. HTTPS is ein sicheres Protokoll zur Übertragung von Daten über das Internet. Es verschlüsselt die Kommunikation zwischen Client und Server über TLS/SSL, schützt also vor Mitlesen und Manipulation.

Außerdem ist eine Passwortsicherheit erforderlich. Passwörter werden lokal vor der Übertragung gehasht, z. B. mit SHA-256. Serverseitig wird das Passwort erneut gehasht und gegen gespeicherte Hashes geprüft.

Für eine sichere, tokenbasierte Authentifizierung ist OAuth2 oder JWT einzusetzen.

2. API-Integration und Kommunikation mit der Datenbank:
   Für die API-Integration würde ich einfache, klar benannte Endpunkte nutzen, z. B. login, start, stop, damit die Kommunikation zwischen Frontend und Backend übersichtlich bleibt. Die API würde im Backend Requests entgegennehmen, die Daten prüfen und dann an die passende Logik weiterleiten.

Die Kommunikation mit der Datenbank würde ich über klar getrennte Module oder Klassen lösen, z. B. eine Klasse für Benutzer und eine für Zeiteinträge. So bleibt der Code strukturiert, leichter testbar und man kann bei Bedarf später auf eine andere Datenbank umsteigen, ohne die ganze Logik neu schreiben zu müssen.
```
