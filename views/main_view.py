import tkinter as tk
from tkinter import ttk
from tkinter import messagebox
from logic.time_logic import (
    start_stoppuhr, stopp_stoppuhr, manuelle_eingaben_bestätigung
)

class MainView(tk.Frame):
    """
    Hauptansicht nach Login. Zeiterfassung durch Start/Stopp oder manuelle Eingabe.
    """

    def __init__(self, master, username, logout_callback):
        super().__init__(master)
        self.master = master
        self.username = username
        self.logout_callback = logout_callback
        self.pack()
        self._build_ui()

    def _build_ui(self):
        self.master.title("Zeiterfassung")

        # Dropdown für Aktivität
        tk.Label(self, text="Aktivität auswählen:", font=("Arial", 10)).pack(pady=(15, 0))
        aktivitaeten = [
            "Arbeit mit Klient", "Betreuungskind krank", "Dienstreise", "Dokumentation",
            "Fortbildung", "Interne Planung", "Eigenes Kind krank", "Krank", "Pause",
            "Sonstige bezahlt", "Sonstige unbezahlt", "Teammeeting", "Urlaub", "Zeitausgleich"
        ]
        self.aktivitaet = tk.StringVar(value=aktivitaeten[0])
        ttk.Combobox(self, textvariable=self.aktivitaet, values=aktivitaeten, state="readonly", width=35).pack(padx=20, pady=15)

        # Eingabefelder vorbereiten
        def zeitfeld(parent):
            entry = tk.Entry(parent, width=21, fg="grey")
            entry.insert(0, "DD.MM.YYYY HH:MM")

            def on_focus_in(event):
                if entry.get() == "DD.MM.YYYY HH:MM":
                    entry.delete(0, tk.END)
                    entry.config(fg="black")

            def on_focus_out(event):
                if not entry.get():
                    entry.insert(0, "DD.MM.YYYY HH:MM")
                    entry.config(fg="grey")
                else:
                    entry.config(fg="black")

            entry.bind("<FocusIn>", on_focus_in)
            entry.bind("<FocusOut>", on_focus_out)

            return entry

        # Start-Input + Button
        start_frame = tk.Frame(self)
        start_frame.pack(pady=(20, 5))
        tk.Button(start_frame, text="Start", width=5, command=self._start, bg="green", fg="white").pack(side=tk.LEFT)
        self.start_eingabe = zeitfeld(start_frame)
        self.start_eingabe.pack(side=tk.LEFT, padx=(10, 0))

        # Daueranzeige
        self.timer_label = tk.Label(self, text="Dauer: 0 Minuten", font=("Arial", 11, "bold"))
        self.timer_label.pack(pady=10)

        # Stopp-Input + Button
        stopp_frame = tk.Frame(self)
        stopp_frame.pack(pady=5)
        tk.Button(stopp_frame, text="Stopp", width=5, command=self._stopp, bg="red", fg="white").pack(side=tk.LEFT)
        self.stopp_eingabe = zeitfeld(stopp_frame)
        self.stopp_eingabe.pack(side=tk.LEFT, padx=(10, 0))

        # Manuelle Bestätigung
        self.btn_manuell = tk.Button(self, text="Manuelle Bestätigung", width=25, command=self._manuell)
        self.btn_manuell.pack(pady=5)

        # Übersicht öffnen
        self.btn_uebersicht = tk.Button(self, text="Übersicht öffnen", width=25, command=self._uebersicht_anzeigen)
        self.btn_uebersicht.pack(pady=5)

        # Logout
        tk.Button(self, text="Logout", width=25, command=self.logout_callback).pack(pady=5)

    def _start(self):
        start_stoppuhr(
            aktivitaet_name=self.aktivitaet.get(),
            timer_label=self.timer_label,
            btn_manuell=self.btn_manuell
        )

    def _stopp(self):
        stopp_stoppuhr(
            timer_label=self.timer_label,
            btn_manuell=self.btn_manuell,
            benutzername=self.username
        )

    def _manuell(self):
        result = manuelle_eingaben_bestätigung(
            start_str=self.start_eingabe.get(),
            stopp_str=self.stopp_eingabe.get(),
            aktivitaet=self.aktivitaet.get(),
            timer_label=self.timer_label,
            benutzername=self.username
        )
        self.timer_label.config(text=result)

    def _uebersicht_anzeigen(self):
        messagebox.showinfo("Übersicht", "In Bearbeitung.")
