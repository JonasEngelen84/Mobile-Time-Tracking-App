import tkinter as tk
from tkinter import messagebox
from logic.auth_logic import registrieren

class RegisterView(tk.Frame):
    """
    Ansicht für Benutzer-Registrierung. Nutzt auth_logic zur Benutzererstellung.
    """

    def __init__(self, master, switch_to_login):
        super().__init__(master)
        self.master = master
        self.switch_to_login = switch_to_login
        self._build_ui()

    def _build_ui(self):
        tk.Label(self, text="Registrieren", font=("Arial", 14, "bold")).pack(pady=10)

        # --- Benutzername (Label + Entry) ---
        benutzer_frame = tk.Frame(self)
        benutzer_frame.pack(pady=5)

        tk.Label(benutzer_frame, text="Benutzername:").pack()
        self.username_entry = tk.Entry(benutzer_frame, width=23)
        self.username_entry.pack()

        # --- Passwort (Label + Entry) ---
        passwort_frame = tk.Frame(self)
        passwort_frame.pack(pady=5)

        tk.Label(passwort_frame, text="Passwort:").pack()
        self.password_entry = tk.Entry(passwort_frame, show="*", width=23)
        self.password_entry.pack()

        # --- Passwort-Wiederholung (Label + Entry) ---
        wiederholung_frame = tk.Frame(self)
        wiederholung_frame.pack(pady=5)

        tk.Label(wiederholung_frame, text="Passwort wiederholen:").pack()
        self.password_repeat_entry = tk.Entry(wiederholung_frame, show="*", width=23)
        self.password_repeat_entry.pack()

        # --- Buttons ---
        tk.Button(self, text="Registrieren", width=19, command=self._register).pack(pady=15)
        tk.Button(self, text="Zurück zum Login", width=19, command=self.switch_to_login).pack()


    def _register(self):
        username = self.username_entry.get().strip()
        password = self.password_entry.get().strip()
        confirm = self.password_repeat_entry.get().strip()

        erfolg, meldung = registrieren(username, password, confirm)

        if erfolg:
            messagebox.showinfo("Erfolg", meldung)
            self.switch_to_login()
        else:
            messagebox.showerror("Fehler", meldung)
