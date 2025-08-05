import 'package:flutter/material.dart';  // Flutter-Bibliothek für grafische Oberfläche
import 'package:frontend_flutter/api/register_api.dart';  // Zur Kommunikation mit API

// Registrierungs-Oberfläche:
// Zeigt drei Eingabefelder (Benutzername, Passwort und Passwort wiederholen) sowie zwei Buttons:
// - Einen Button zum registrieren (verbindet sich mit der API)
// - Einen Button zum Wechseln zur Login-Oberfläche
// Die tatsächliche Registrierungs-Logik (API-Aufruf) wird in "register_command.py" ausgeführt.
class RegisterView extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onCancel;

  const RegisterView({
    Key? key, // Optionaler Schlüssel für das Widget (z. B. für Tests oder eindeutige Identifikation in der Baumstruktur)
    required this.onRegister, // Wird beim Klick auf "Registrieren" ausgeführt. Erwartet drei Strings: Benutzername, Passwort und Passwort wiederholen.
    required this.onCancel, // Wird beim Klick auf "Zurück" ausgeführt. Parameterlos (VoidCallback).
  }) : super(key: key); // Ruft den Konstruktor der Oberklasse (StatefulWidget) auf und übergibt den optionalen Schlüssel

  // Diese Methode ist notwendig bei einem StatefulWidget. (Flutter-Widget, das sich zur Laufzeit verändern kann.)
  // Sie erstellt und verbindet den Zustand (State) des Widgets. In diesem Fall heißt die Zustandsklasse _RegisterViewState.
  // Verwendung: Eingaben verwalten, UI aktualisieren und Lebenszyklus steuern (z. B. initState, dispose etc.).
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

// Der Zustand (State) der RegisterView.
// Hier werden Eingabefelder verwaltet und die Oberfläche aktualisiert.
class _RegisterViewState extends State<RegisterView> {
  // Speicherung der Eingaben
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatpasswordController = TextEditingController();

  bool _activeLoading = false;  // Wird verwendet, um zu zeigen, ob gerade geladen wird  
  String _report = '';  // Diese Variable speichert die Rückmeldung (z. B. "Erfolgreich registriert")

  // Diese Methode wird aufgerufen, wenn der Benutzer auf „Registrieren“ klickt
  Future<void> _registerUser() async {
    // Trim entfernt Leerzeichen am Anfang und Ende
    final username = _usernameController.text.trim();
    final password = d.text.trim();
    final passwordWdh = _repeatpasswordController.text.trim();

    // Wenn ein Feld leer ist → Hinweis anzeigen
    if (username.isEmpty || password.isEmpty || passwordWdh.isEmpty) {
      setState(() => _report = 'Bitte alle Felder ausfüllen.');
      return;
    }

    // Wenn die beiden Passwörter nicht gleich sind → Hinweis anzeigen
    if (password != passwordWdh) {
      setState(() => _report = 'Passwörter stimmen nicht überein.');
      return;
    }

    // Ladeanzeige aktivieren
    setState(() {
      _activeLoading = true;
      _report = '';
    });

    // An die API senden → registrieren() aus auth_api.dart wird aufgerufen
    final rueckmeldung = await register(username, password);

    // Ergebnis anzeigen und Ladeanzeige abschalten
    setState(() {
      _activeLoading = false;
      _report = rueckmeldung;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrieren"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Eingabefelder
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Benutzername", border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort", border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordRepeatController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort wiederholen", border: OutlineInputBorder(),),
            ),
            const SizedBox(height: 24),

            // Registrieren-Button
            ElevatedButton(
              onPressed: () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text.trim();
                final passwordRepeat = _passwordRepeatController.text.trim();

                final (success, message) = await registerUser(username, password, passwordRepeat,);

                if (success) {
                  widget.onRegisterSuccess();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Registrierung fehlgeschlagen"),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Registrieren"),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onCancel,
              child: const Text("Zurück zum Login"),
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
    _repeatpasswordController.dispose();
    super.dispose();
  }
