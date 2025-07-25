import tkinter as tk
from tkinter import messagebox
from logic.auth_logic import anmelden

class LoginView(tk.Frame):
    def __init__(self, master, switch_to_register, login_successful_callback):
        super().__init__(master)
        self.master = master
        self.switch_to_register = switch_to_register
        self.login_successful_callback = login_successful_callback
        self._build_ui()
        zentriere_fenster(self.master)

    def _build_ui(self):
        tk.Label(self, text="Login", font=("Arial", 14, "bold")).pack(pady=10)

        # Benutzername (Label + Entry)
        benutzer_frame = tk.Frame(self)
        benutzer_frame.pack(pady=5)
        tk.Label(benutzer_frame, text="Benutzername:").pack()
        self.username_entry = tk.Entry(benutzer_frame, width=23)
        self.username_entry.pack()

        # Passwort (Label + Entry)
        passwort_frame = tk.Frame(self)
        passwort_frame.pack(pady=5)
        tk.Label(passwort_frame, text="Passwort:").pack()
        self.password_entry = tk.Entry(passwort_frame, show="*", width=23)
        self.password_entry.pack()

        # Login
        tk.Button(self, text="Login", width=19, command=self._login).pack(pady=15)

        # Registrieren
        tk.Button(self, text="Neuen Benutzer erstellen", command=self.switch_to_register).pack()

    def _login(self):
        username = self.username_entry.get().strip()
        password = self.password_entry.get().strip()

        erfolg, meldung = anmelden(username, password)

        if erfolg:
            self.login_successful_callback(username)
        else:
            messagebox.showerror("Login fehlgeschlagen", meldung)

def zentriere_fenster(fenster, breite=210, höhe=380):
    fenster.update_idletasks()
    screen_width = fenster.winfo_screenwidth()
    screen_height = fenster.winfo_screenheight()
    x = (screen_width // 2) - (breite // 2)
    y = (screen_height // 2) - (höhe // 2)
    fenster.geometry(f"{breite}x{höhe}+{x}+{y}")