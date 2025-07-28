import 'package:flutter/material.dart'; // Flutter-Bibliothek für grafische Oberfläche

// Dies ist die Login-Oberfläche der App.
// Sie zeigt zwei Eingabefelder (Benutzername und Passwort) sowie zwei Buttons:
// - Einen Button zum Einloggen (verbindet sich mit der API)
// - Einen Button zum Wechseln zur Registrierungsansicht
// Die tatsächliche Login-Logik (API-Aufruf) wird in einer anderen Datei ausgeführt.
class LoginAnsicht extends StatefulWidget {  
  final void Function(String benutzername, String passwort) beiLogin; // Wird aufgerufen, wenn der Nutzer sich einloggen möchte.
  final VoidCallback zuRegistrierungWechseln; // Wird aufgerufen, wenn der Nutzer zur Registrierungsansicht wechseln möchte.

  // Konstruktor
  const LoginAnsicht({
    Key? key, // Optionaler Schlüssel für das Widget (z. B. für Tests oder eindeutige Identifikation in der Baumstruktur)
    required this.beiLogin, // Wird beim Klick auf "Einloggen" ausgeführt. Erwartet zwei Strings: Benutzername und Passwort.
    required this.zuRegistrierungWechseln,  // Wird beim Klick auf "Registrieren" ausgeführt. Parameterlos (VoidCallback).
  }) : super(key: key); // Ruft den Konstruktor der Oberklasse (StatefulWidget) auf und übergibt den optionalen Schlüssel

  // Diese Methode ist notwendig bei einem StatefulWidget. (Flutter-Widget, das sich zur Laufzeit verändern kann.)
  // Sie erstellt und verbindet den Zustand (State) des Widgets. In diesem Fall heißt die Zustandsklasse _LoginAnsichtZustand.
  //Flutter verwendet diesen Zustand, um:
  // Eingaben zu verwalten, das UI zu aktualisieren und den Lebenszyklus zu steuern (z. B. initState, dispose etc.).
  @override
  State<LoginAnsicht> createState() => _LoginAnsichtZustand();
}

// Der Zustand (State) der LoginAnsicht.
// Hier werden Eingabefelder verwaltet und die Oberfläche aktualisiert.
class _LoginAnsichtZustand extends State<LoginAnsicht> {
  // Eingabefeld für den Benutzernamen
  final TextEditingController _benutzernameEingabe = TextEditingController();

  // Eingabefeld für das Passwort (mit verdeckter Eingabe)
  final TextEditingController _passwortEingabe = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anmeldung"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Innenabstand rund um die Felder
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertikal zentriert
          crossAxisAlignment: CrossAxisAlignment.stretch, // Volle Breite nutzen
          children: [
            // Eingabefeld: Benutzername
            TextField(
              controller: _benutzernameEingabe,
              decoration: const InputDecoration(
                labelText: "Benutzername",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Abstand

            // Eingabefeld: Passwort (verdeckte Eingabe)
            TextField(
              controller: _passwortEingabe,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Passwort",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24), // Abstand

            // Login-Button: Übergibt Benutzername + Passwort an die Login-Logik
            ElevatedButton(
              onPressed: () {
                widget.beiLogin(
                  _benutzernameEingabe.text.trim(),
                  _passwortEingabe.text.trim(),
                );
              },
              child: const Text("Einloggen"),
            ),

            const SizedBox(height: 12),

            // Wechsel zur Registrierung
            TextButton(
              onPressed: widget.zuRegistrierungWechseln,
              child: const Text("Noch kein Konto? Jetzt registrieren."),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Eingabefelder aufräumen, wenn die Ansicht geschlossen wird
    _benutzernameEingabe.dispose();
    _passwortEingabe.dispose();
    super.dispose();
  }
}
