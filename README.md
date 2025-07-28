```
Mobile Time Tracking App

✨ Project Description
This project is a modular application for recording, storing, and managing working hours.
Goal is to provide a simple, local time tracking solution (using register & login) that operates
without external dependencies and supports both stopwatch-based tracking and manual time entries.
The application deliberately separates user management, time logic, formatting, and data storage
into clearly structured modules following the "Separation of Concerns" principle.
```
```
🔧 Technologies
• Python 3.10+ – Programming language
• SQLite – Relational database for local persistent storage
• Tkinter – Frontend
• Datetime – Time handling
• abc module – Abstract Base Classes (interfaces) for a testable architecture
• Modular design – Separation of business logic, storage, interfaces, and formatting for maintainability
```
```
🔍 Features
• User registration and login (local, SQLite)
• Action selection via drop-down menu
• Time tracking via start/stop stopwatch
• Manual entry of working hours
• Consistent time formatting (e.g., “2 hours 30 minutes”)
• Data persistence using SQLite
• Extendable through interface-based architecture
```
```
🚧 Planned Extensions
The next development stage includes the following planned features:
• Expansion into a mobile app
• Overview of already recorded times
• Export of recorded times as a work hours report (PDF)
• Transport encryption (HTTPS)
• Unit tests & CI/CD pipeline
```
```
📄 Database Structure – SQLite
The application uses a SQLite database (zeiterfassung.db) with two main tables:
    Table: nutzer (Stores user accounts for authentication)
    • id
    • benutzername (username)
    • passwort (password)

    Table: zeiterfassung (Stores all recorded working time entries)
    • id
    • aktivitaet (activity)
    • start (start time)
    • ende (end time)
    • dauer_min (duration in minutes)
    • benutzer (user)

(If database does not exist it will be automaticly created)
```
