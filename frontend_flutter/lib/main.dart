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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginView(
        onLogin: (user) {
          print('User eingeloggt: $user');
        },
        onRegister: () {
          print('Zur Registrierung wechseln');
        },
      ),
    );
  }
}
