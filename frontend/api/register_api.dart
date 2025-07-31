import 'dart:convert'; // Für die Umwandlung zwischen Dart-Objekten und JSON
import 'package:http/http.dart' as http; // Für HTTP-Anfragen zum Backend

/// Diese Funktion sendet eine Registrierung an das Python/Flask-Backend.
/// Es wird eine POST-Anfrage an den /register-Endpunkt gesendet.
///
/// Parameter:
/// - [username]: der gewünschte Benutzername
/// - [password]: das gewünschte Passwort
/// - [passwordRepeat]: Passwort-Wiederholung zur Bestätigung
///
/// Rückgabe:
/// - Ein `Map<String, dynamic>`-Objekt, das aus der JSON-Antwort des Servers entsteht.
///   Enthält z. B. die Schlüssel "success" (bool) und "message" (String).
///
/// Fehlerfall:
/// - Wenn der Server nicht erfolgreich antwortet (z. B. kein 200er-Status), wird eine Exception geworfen.
Future<Map<String, dynamic>> registerUser(
  String username,
  String password,
  String passwordRepeat,
) async {
  // Die Adresse des Python-Backends
  // Wenn du auf Android-Emulator arbeitest, nimm: http://10.0.2.2:5000
  final url = Uri.parse("http://localhost:5000/register");

  // Sende eine POST-Anfrage an das Backend
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json", // Wir senden JSON-Daten
    },
    body: jsonEncode({
      // Die eigentlichen Nutzerdaten, die wir an das Backend schicken
      "user": username,
      "password": password,
      "password_repeat": passwordRepeat,
    }),
  );

  // Wenn die Antwort vom Server erfolgreich war (HTTP-Status 200)
  if (response.statusCode == 200) {
    // Wandle die Antwort (JSON-Text) in eine Dart-Map um
    return jsonDecode(response.body);
  } else {
    // Wenn etwas schiefläuft: Fehler werfen mit Statuscode
    throw Exception("Registrierung fehlgeschlagen. Fehlercode: ${response.statusCode}");
  }
}
