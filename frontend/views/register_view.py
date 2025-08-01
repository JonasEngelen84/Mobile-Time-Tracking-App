import tkinter as tk
from tkinter import messagebox
from backend.services.auth_services import register

""" Ansicht für Benutzer-Registrierung. Nutzt auth_services zur Benutzererstellung. """
class RegisterView(tk.Frame):    
    def __init__(self, master, switch_to_login):
        super().__init__(master)
        self.master = master
        self.switch_to_login = switch_to_login
        self._build_ui()

    def _build_ui(self):
        # Überschrift
        tk.Label(self, text="Registrieren", font=("Arial", 14, "bold")).pack(pady=10)

        # Benutzername (Label + Eingabefeld)
        username_frame = tk.Frame(self)
        username_frame.pack(pady=5)
        tk.Label(username_frame, text="Benutzername:").pack()
        self.username_entry = tk.Entry(username_frame, width=23)
        self.username_entry.pack()

        # Passwort (Label + Eingabefeld)
        password_frame = tk.Frame(self)
        password_frame.pack(pady=5)
        tk.Label(password_frame, text="Passwort:").pack()
        self.password_entry = tk.Entry(password_frame, show="*", width=23)
        self.password_entry.pack()

        # Passwort-Wiederholung (Label + Eingabefeld)
        repeat_frame = tk.Frame(self)
        repeat_frame.pack(pady=5)
        tk.Label(repeat_frame, text="Passwort wiederholen:").pack()
        self.password_repeat_entry = tk.Entry(repeat_frame, show="*", width=23)
        self.password_repeat_entry.pack()

        # Registrieren-Button
        tk.Button(
            self,
            text="Registrieren",
            width=19,
            command=self.handle_register
        ).pack(pady=15)

        # Zurück-Button
        tk.Button(
            self,
            text="Zurück zum Login",
            width=19,
            command=self.switch_to_login
        ).pack()

    def handle_register(self):
        """
        Führt die Registrierung aus und verarbeitet die Rückgabe.
        Zeigt bei Erfolg/Fehler eine entsprechende Nachricht an.
        """
        username = self.username_entry.get().strip()
        password = self.password_entry.get().strip()
        password_repeat = self.password_repeat_entry.get().strip()

        success, title, message = register(username, password, password_repeat)

        if success:
            messagebox.showinfo(title, message)
            self.switch_to_login()
        else:
            messagebox.showerror(title, message)
