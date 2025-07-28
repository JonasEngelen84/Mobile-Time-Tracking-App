import tkinter as tk
from Befehle.auth_befehle import anmelden

"""Ansicht für Benutzer-Login. Nutzt auth_logic zur Benutzererstellung."""
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

        # Benutzername (Label + Eingabefeld)
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

        # Login button
        tk.Button(
            self,
            text="Login",
            width=19,
            command=lambda: anmelden(
                self.username_entry.get().strip(),
                self.password_entry.get().strip(),
                self.login_successful_callback  # z. B. zum Wechsel ins MainView
            )
        ).pack(pady=15)

        # Registrieren button
        tk.Button(self, text="Neuen Benutzer erstellen", command=self.switch_to_register).pack()
    
def zentriere_fenster(fenster, breite=210, höhe=380):
    fenster.update_idletasks()
    screen_width = fenster.winfo_screenwidth()
    screen_height = fenster.winfo_screenheight()
    x = (screen_width // 2) - (breite // 2)
    y = (screen_height // 2) - (höhe // 2)
    fenster.geometry(f"{breite}x{höhe}+{x}+{y}")