import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeiterfassung',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginView(
        onLogin: (benutzername, passwort) {
          // TODO: Anmelde-Logik verknüpfen
          print("Login: $benutzername / $passwort");
        },
        onSwitchToRegister: () {
          // TODO: Navigation zur RegisterView
          print("Zur Registrierung wechseln");
        },
      ),
    );
  }
}