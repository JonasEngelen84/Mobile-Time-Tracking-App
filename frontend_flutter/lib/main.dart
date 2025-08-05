import 'package:flutter/material.dart';
import 'views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeiterfassung',
      debugShowCheckedModeBanner: false,
      home: MainView(
        username: "demo_user",
        onLogout: () {
          print("Logout gedrückt");
        },
        onStart: (activity) {
          print("Start gedrückt mit Aktivität: $activity");
        },
        onStop: () {
          print("Stopp gedrückt");
        },
        onManualConfirm: (start, stop, activity) {
          print("Manuelle Eingabe: $start - $stop ($activity)");
        },
        onShowOverview: () {
          print("Übersicht öffnen gedrückt");
        },
      ),
    );
  }
}
