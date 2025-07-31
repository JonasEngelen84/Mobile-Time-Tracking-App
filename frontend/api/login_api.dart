import 'dart:convert'; // Für das Umwandeln von Dart-Objekten in JSON
import 'package:http/http.dart' as http; // Für HTTP-Kommunikation mit dem Backend

/// Diese Funktion versucht, einen Benutzer über das Flask-Backend einzuloggen.
/// Es wird eine POST-Anfrage an den /login-Endpunkt geschickt.
///
/// Parameter:
/// - [username]: der eingegebene Benutzername
/// - [password]: das eingegebene Passwort
///
/// Rückgabe:
/// - Eine Map mit zwei Werten:
///   - "success": true oder false
///   - "message": Rückmeldung vom Server (z. B. Fehlertext oder Erfolgsnachricht)
///
/// Fehlerfall:
/// - Wenn die Serverantwort nicht erfolgreich ist, wird eine Exception geworfen.
Future<Map<String, dynamic>> loginUser(
  String username,
  String password,
) async {
  // URL des Backends
  // Mit Android-Emulator => 10.0.2.2 (statt localhost)
  final url = Uri.parse("http://localhost:5000/login");

  // HTTP-POST-Anfrage senden
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json", // Daten als JSON senden
    },
    body: jsonEncode({
      // Sende Benutzerdaten im JSON-Format
      "user": username,
      "password": password,
    }),
  );

  // Prüfe, ob die Antwort erfolgreich war
  if (response.statusCode == 200) {
    // Wandelt den JSON-Body in eine Dart-Map um
    return jsonDecode(response.body);
  } else {
    // Bei Fehler: wirf eine Exception mit Statuscode
    throw Exception("Login fehlgeschlagen. Fehlercode: ${response.statusCode}");
  }
}
