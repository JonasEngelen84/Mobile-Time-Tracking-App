import tkinter as tk
from tkinter import messagebox
from backend.services.auth_services import login

""" Ansicht für Benutzer-Login. Nutzt auth_services zur Benutzeranmeldung. """
class LoginView(tk.Frame):
    def __init__(self, master, switch_to_register, login_successful_callback):
        super().__init__(master)
        self.master = master
        self.switch_to_register = switch_to_register
        self.login_successful_callback = login_successful_callback
        self._build_ui()
        zentriere_fenster(self.master)

    def _build_ui(self):
        # Überschrift
        tk.Label(self, text="Login", font=("Arial", 14, "bold")).pack(pady=10)

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

        # Login-Button
        tk.Button(
            self,
            text="Login",
            width=19,
            command=self.handle_login  # Verknüpft mit eigener Logik
        ).pack(pady=15)

        # Button zum Registrieren
        tk.Button(self, text="Neuen Benutzer erstellen", command=self.switch_to_register).pack()

    def handle_login(self):
        """
        Ruft die login-Funktion auf und behandelt Rückgabe.
        Zeigt bei Fehlern eine Messagebox an, bei Erfolg wird Callback ausgelöst.
        """
        username = self.username_entry.get().strip()
        password = self.password_entry.get().strip()

        success, message = login(username, password)

        if success:
            self.login_successful_callback(username)
        else:
            messagebox.showerror("Login fehlgeschlagen", message)

def zentriere_fenster(fenster, breite=210, höhe=380):
    """
    Zentriert das Fenster auf dem Bildschirm.
    """
    fenster.update_idletasks()
    screen_width = fenster.winfo_screenwidth()
    screen_height = fenster.winfo_screenheight()
    x = (screen_width // 2) - (breite // 2)
    y = (screen_height // 2) - (höhe // 2)
    fenster.geometry(f"{breite}x{höhe}+{x}+{y}")
