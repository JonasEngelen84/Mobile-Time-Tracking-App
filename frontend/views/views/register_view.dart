import 'package:flutter/material.dart';  // Flutter-Bibliothek für grafische Oberfläche
import '../api/auth_apis/register_api.dart';  // Zur Kommunikation mit API

// Registrierungs-Oberfläche:
// Zeigt drei Eingabefelder (Benutzername, Passwort und Passwort wiederholen) sowie zwei Buttons:
// - Einen Button zum registrieren (verbindet sich mit der API)
// - Einen Button zum Wechseln zur Login-Oberfläche
// Die tatsächliche Registrierungs-Logik (API-Aufruf) wird in "register_command.py" ausgeführt.
class RegisterView extends StatefulWidget {
  const RegisterView({super.key}); // Konstruktor

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
  Future<void> _benutzerRegistrieren() async {
    // Trim entfernt Leerzeichen am Anfang und Ende
    final benutzername = _usernameController.text.trim();
    final passwort = d.text.trim();
    final passwortWdh = _repeatpasswordController.text.trim();

    // Wenn ein Feld leer ist → Hinweis anzeigen
    if (benutzername.isEmpty || passwort.isEmpty || passwortWdh.isEmpty) {
      setState(() => _report = 'Bitte alle Felder ausfüllen.');
      return;
    }

    // Wenn die beiden Passwörter nicht gleich sind → Hinweis anzeigen
    if (passwort != passwortWdh) {
      setState(() => _report = 'Passwörter stimmen nicht überein.');
      return;
    }

    // Ladeanzeige aktivieren
    setState(() {
      _activeLoading = true;
      _report = '';
    });

    // An die API senden → registrieren() aus auth_api.dart wird aufgerufen
    final rueckmeldung = await registrieren(benutzername, passwort);

    // Ergebnis anzeigen und Ladeanzeige abschalten
    setState(() {
      _activeLoading = false;
      _report = rueckmeldung;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrieren')),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Eingabefeld für den Benutzernamen
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),

            // Eingabefeld für das Passwort
            TextField(
              controller: d,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true, // Passwort nicht im Klartext anzeigen
            ),

            // Eingabefeld für die Wiederholung des Passworts
            TextField(
              controller: _repeatpasswordController,
              decoration: const InputDecoration(labelText: 'Passwort wiederholen'),
              obscureText: true,
            ),

            const SizedBox(height: 20), // Abstand

            // Wenn gerade geladen wird, zeige ein Ladesymbol – sonst den Button
            _activeLoading
                ? const CircularProgressIndicator() // Ladeanzeige
                : ElevatedButton(
                    onPressed: _benutzerRegistrieren,
                    child: const Text('Registrieren'),
                  ),

            const SizedBox(height: 10),

            // Zeige Rückmeldung (z. B. „Benutzer existiert bereits“)
            Text(
              _report,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
