import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  final void Function(String benutzername, String passwort) onLogin;
  final VoidCallback onSwitchToRegister;

  const LoginView({
    Key? key,
    required this.onLogin,
    required this.onSwitchToRegister,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _benutzernameController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _benutzernameController,
              decoration: const InputDecoration(labelText: "Benutzername"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwortController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onLogin(
                  _benutzernameController.text.trim(),
                  _passwortController.text.trim(),
                );
              },
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: widget.onSwitchToRegister,
              child: const Text("Neuen Benutzer erstellen"),
            )
          ],
        ),
      ),
    );
  }
}
