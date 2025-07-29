import 'package:flutter/material.dart'; // Flutter-Bibliothek für grafische Oberfläche
import '../api/auth_apis/login_api.dart';  // Zur Kommunikation mit API

// Login-Oberfläche:
// Zeigt zwei Eingabefelder (Benutzername und Passwort) sowie zwei Buttons:
// - Einen Button zum Einloggen (verbindet sich mit der API)
// - Einen Button zum Wechseln zur Registrierungs-Oberfläche
// Die tatsächliche Login-Logik (API-Aufruf) wird in "login_command.py" ausgeführt.
class LoginView extends StatefulWidget {  
  final void Function(String benutzername, String passwort) onLogin; // Wird aufgerufen, wenn der Nutzer sich einloggen möchte.
  final VoidCallback onRegister; // Wird aufgerufen, wenn der Nutzer zur Registrierungsansicht wechseln möchte.

  // Konstruktor
  const LoginView({
    Key? key, // Optionaler Schlüssel für das Widget (z. B. für Tests oder eindeutige Identifikation in der Baumstruktur)
    required this.onLogin, // Wird beim Klick auf "Einloggen" ausgeführt. Erwartet zwei Strings: Benutzername und Passwort.
    required this.onRegister,  // Wird beim Klick auf "Registrieren" ausgeführt. Parameterlos (VoidCallback).
  }) : super(key: key); // Ruft den Konstruktor der Oberklasse (StatefulWidget) auf und übergibt den optionalen Schlüssel

  // Diese Methode ist notwendig bei einem StatefulWidget. (Flutter-Widget, das sich zur Laufzeit verändern kann.)
  // Sie erstellt und verbindet den Zustand (State) des Widgets. In diesem Fall heißt die Zustandsklasse _LoginViewState.
  // Verwendung: Eingaben verwalten, UI aktualisieren und Lebenszyklus steuern (z. B. initState, dispose etc.).
  @override
  State<LoginView> createState() => _LoginViewState();
}

// Der Zustand (State) der LoginView.
// Hier werden Eingabefelder verwaltet und die Oberfläche aktualisiert.
class _LoginViewState extends State<LoginView> {
  // Speicherung der Eingaben
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Benutzername",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16), // Abstand

            // Eingabefeld: Passwort (verdeckte Eingabe)
            TextField(
              controller: _passwordController,
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
                loginUser(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );
              },
              child: const Text("Einloggen"),
            ),

            const SizedBox(height: 12),

            // Wechsel zur Registrierung
            TextButton(
              onPressed: widget.onRegister,
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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
