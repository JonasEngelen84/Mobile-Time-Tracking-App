import tkinter as tk
from views.login_view import LoginView
from views.register_view import RegisterView
from views.main_view import MainView

class Application(tk.Tk):
    """
    Hauptanwendungsklasse für die Zeiterfassungs-GUI.
    Verwaltet den Wechsel zwischen Login-, Register- und MainView.
    """    
    def __init__(self):
        super().__init__()
        self.title("Zeiterfassung mit Login")
        self.geometry("210x380")
        self.resizable(False, False)
        self.current_view = None
        self.zeige_login_view()

    def zeige_login_view(self):
        """
        Zeigt die Login-Oberfläche.
        Wird aufgerufen beim Start oder nach Logout.
        """
        if self.current_view:
            self.current_view.destroy()
        self.current_view = LoginView(
            master=self,
            switch_to_register=self.zeige_register_view,
            login_successful_callback=self.zeige_main_view
        )
        self.current_view.pack(fill="both", expand=True)

    def zeige_register_view(self):
        """
        Zeigt die Registrierungs-Oberfläche.
        Wird aufgerufen, wenn der Benutzer auf "Registrieren" klickt.
        """
        if self.current_view:
            self.current_view.destroy()
        self.current_view = RegisterView(
            master=self,
            switch_to_login=self.zeige_login_view
        )
        self.current_view.pack(fill="both", expand=True)

    def zeige_main_view(self, username):
        """
        Zeigt die Hauptansicht zur Zeiterfassung.
        Wird aufgerufen nach erfolgreichem Login.
        """
        if self.current_view:
            self.current_view.destroy()
        self.current_view = MainView(
            master=self,
            username=username,
            logout_callback=self.zeige_login_view
        )
        self.current_view.pack(fill="both", expand=True)

"""Einstiegspunkt der Anwendung"""
if __name__ == "__main__":
    app = Application()
    app.mainloop()
