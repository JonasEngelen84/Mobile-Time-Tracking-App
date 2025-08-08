import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/register_api.dart';

/// Diese Ansicht ermöglicht die Benutzerregistrierung.
/// - Benutzername, Passwort, Passwort-Wiederholung
/// - Registrierung über Backend-API
/// - Minimale Eingabeprüfung im Frontend
class RegisterView extends StatefulWidget {
  final VoidCallback onRegisterSuccess;
  final VoidCallback onGoToLogin;

  const RegisterView({
    super.key,
    required this.onRegisterSuccess,
    required this.onGoToLogin, // Callback zum Wechsel zurück zur Login-Seite
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Eingabefelder
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  bool _isLoading = false; // Ladeanzeige während der Registrierung
  String _statusMessage = ''; // Feedback-Meldung (z. B. Fehlermeldung)

  /// Diese Methode wird beim Klick auf „Registrieren“ aufgerufen.
  /// Sie ruft die API auf und verarbeitet das Ergebnis.
  Future<void> _registerUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final repeatPassword = _repeatPasswordController.text.trim();

    // Minimale Validierung im Frontend (Felder nicht leer)
    if (username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      setState(() => _statusMessage = "Bitte alle Felder ausfüllen.");
      return;
    }

    // Ladeanzeige aktivieren
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    // Anfrage an Backend-API stellen
    final result = await registerUser(username, password, repeatPassword);

    // Ladeanzeige deaktivieren
    setState(() {
      _isLoading = false;
    });

    final success = result["success"];
    final message = result["message"];

    if (success) {
      // Erfolgreich registriert → Zurück zur Login-Ansicht
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Registrierung erfolgreich"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog schließen
                widget.onGoToLogin();     // Zurück zur Login-Ansicht
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      // Registrierung fehlgeschlagen → Meldung anzeigen
      setState(() {
        _statusMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrierung"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Benutzername",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Passwort",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _repeatPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Passwort wiederholen",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser,
              child: const Text("Registrieren"),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onGoToLogin,
              child: const Text("Zurück zur Anmeldung"),
            ),

            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }
}
