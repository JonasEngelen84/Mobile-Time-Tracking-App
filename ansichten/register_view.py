import tkinter as tk
from Befehle.auth_befehle import registrieren

"""Ansicht für Benutzer-Registrierung. Nutzt auth_logic zur Benutzererstellung."""
class RegisterView(tk.Frame):    
    def __init__(self, master, switch_to_login):
        super().__init__(master)
        self.master = master
        self.switch_to_login = switch_to_login
        self._build_ui()

    def _build_ui(self):
        tk.Label(self, text="Registrieren", font=("Arial", 14, "bold")).pack(pady=10)

        # Benutzername (Label + Entry)
        benutzer_frame = tk.Frame(self)
        benutzer_frame.pack(pady=5)

        tk.Label(benutzer_frame, text="Benutzername:").pack()
        self.username_entry = tk.Entry(benutzer_frame, width=23)
        self.username_entry.pack()

        # Passwort (Label + Eingabefeld)
        passwort_frame = tk.Frame(self)
        passwort_frame.pack(pady=5)
        tk.Label(passwort_frame, text="Passwort:").pack()
        self.password_entry = tk.Entry(passwort_frame, show="*", width=23)
        self.password_entry.pack()

        # Passwort-Wiederholung (Label + Eingabefeld)
        wiederholung_frame = tk.Frame(self)
        wiederholung_frame.pack(pady=5)
        tk.Label(wiederholung_frame, text="Passwort wiederholen:").pack()
        self.password_repeat_entry = tk.Entry(wiederholung_frame, show="*", width=23)
        self.password_repeat_entry.pack()

        # Registrieren button
        tk.Button(self, text="Registrieren", width=19,
          command=lambda: registrieren(
              self.username_entry.get().strip(),
              self.password_entry.get().strip(),
              self.password_repeat_entry.get().strip(),
              on_success=self.switch_to_login
          )).pack(pady=15)

        # zurück button
        tk.Button(self, text="Zurück zum Login", width=19, command=self.switch_to_login).pack()
