import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/login_api.dart';

/// Diese Ansicht zeigt das Login-Formular an:
/// - Benutzername und Passwort
/// - Button zum Einloggen
/// - Button zum Wechseln zur Registrierung
class LoginView extends StatefulWidget {
  final void Function(String username) onLoginSuccess;
  final VoidCallback onGoToRegister;

  const LoginView({
    Key? key,
    required this.onLoginSuccess,
    required this.onGoToRegister,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Eingabefelder
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // Ladeanzeige beim Warten auf Backend
  String _statusMessage = ''; // Meldung bei Fehler oder Erfolg

  /// Diese Methode wird beim Klick auf "Einloggen" ausgeführt.
  /// Sie ruft die API auf und verarbeitet das Ergebnis.
  Future<void> _loginUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Minimale Validierung – nicht leer
    if (username.isEmpty || password.isEmpty) {
      setState(() => _statusMessage = "Bitte Benutzername und Passwort eingeben.");
      return;
    }

    // Ladeanzeige aktivieren
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    // Anfrage an das Backend senden – Login prüfen
    final result = await loginUser(username, password);

    // Ladeanzeige deaktivieren
    setState(() {
      _isLoading = false;
    });

    final success = result["success"];
    final message = result["message"];

    if (success) {
      // Wenn erfolgreich eingeloggt → Weiter zur Hauptansicht
      Navigator.pushReplacementNamed(context, '/home', arguments: username);
    } else {
      // Bei Fehler → Dialog anzeigen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login fehlgeschlagen"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anmeldung"),
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
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _loginUser,
              child: const Text("Einloggen"),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onGoToRegister,
              child: const Text("Noch kein Konto? Jetzt registrieren."),
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
    super.dispose();
  }
}
