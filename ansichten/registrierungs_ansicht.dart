import 'package:flutter/material.dart';  // Flutter-Bibliothek für grafische Oberfläche
import '../api/auth_api.dart';           // Importiere meine Datei, die mit der API kommuniziert

// Diese Ansicht zeigt das Registrierungsformular an
class RegistrierungsAnsicht extends StatefulWidget {
  const RegistrierungsAnsicht({super.key}); // Konstruktor

  // Diese Methode ist notwendig bei einem StatefulWidget. (Flutter-Widget, das sich zur Laufzeit verändern kann.)
  // Sie erstellt und verbindet den Zustand (State) des Widgets. In diesem Fall heißt die Zustandsklasse _LoginAnsichtZustand.
  //Flutter verwendet diesen Zustand, um:
  // Eingaben zu verwalten, das UI zu aktualisieren und den Lebenszyklus zu steuern (z. B. initState, dispose etc.).
  @override
  State<RegistrierungsAnsicht> createState() => _RegistrierungsAnsichtZustand();
}

// Das ist die Klasse, die den aktuellen Zustand der Registrierungsansicht verwaltet
class _RegistrierungsAnsichtZustand extends State<RegistrierungsAnsicht> {
  // Diese Textfelder speichern den eingegebenen Text
  final TextEditingController _benutzernameController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();
  final TextEditingController _passwortWiederholenController = TextEditingController();

  // Wird verwendet, um zu zeigen, ob gerade geladen wird
  bool _ladeVorgangAktiv = false;

  // Diese Variable speichert die Rückmeldung (z. B. "Erfolgreich registriert")
  String _meldung = '';

  // Diese Methode wird aufgerufen, wenn der Benutzer auf „Registrieren“ klickt
  Future<void> _benutzerRegistrieren() async {
    // Trim entfernt Leerzeichen am Anfang und Ende
    final benutzername = _benutzernameController.text.trim();
    final passwort = _passwortController.text.trim();
    final passwortWdh = _passwortWiederholenController.text.trim();

    // Wenn ein Feld leer ist → Hinweis anzeigen
    if (benutzername.isEmpty || passwort.isEmpty || passwortWdh.isEmpty) {
      setState(() => _meldung = 'Bitte alle Felder ausfüllen.');
      return;
    }

    // Wenn die beiden Passwörter nicht gleich sind → Hinweis anzeigen
    if (passwort != passwortWdh) {
      setState(() => _meldung = 'Passwörter stimmen nicht überein.');
      return;
    }

    // Ladeanzeige aktivieren
    setState(() {
      _ladeVorgangAktiv = true;
      _meldung = '';
    });

    // An die API senden → registrieren() aus auth_api.dart wird aufgerufen
    final rueckmeldung = await registrieren(benutzername, passwort);

    // Ergebnis anzeigen und Ladeanzeige abschalten
    setState(() {
      _ladeVorgangAktiv = false;
      _meldung = rueckmeldung;
    });
  }

  // Hier wird die Oberfläche gebaut (Layout)
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
              controller: _benutzernameController,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),

            // Eingabefeld für das Passwort
            TextField(
              controller: _passwortController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true, // Passwort nicht im Klartext anzeigen
            ),

            // Eingabefeld für die Wiederholung des Passworts
            TextField(
              controller: _passwortWiederholenController,
              decoration: const InputDecoration(labelText: 'Passwort wiederholen'),
              obscureText: true,
            ),

            const SizedBox(height: 20), // Abstand

            // Wenn gerade geladen wird, zeige ein Ladesymbol – sonst den Button
            _ladeVorgangAktiv
                ? const CircularProgressIndicator() // Ladeanzeige
                : ElevatedButton(
                    onPressed: _benutzerRegistrieren,
                    child: const Text('Registrieren'),
                  ),

            const SizedBox(height: 10),

            // Zeige Rückmeldung (z. B. „Benutzer existiert bereits“)
            Text(
              _meldung,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}