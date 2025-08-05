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
Future<(bool, String)> loginUser(String username, String password) async {
  if (username.isEmpty || password.isEmpty) {
    return (false, "Benutzername und Passwort dürfen nicht leer sein.");
  }

  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final success = data["success"] ?? false;
      final message = data["message"] ?? "Unbekannte Antwort";

      return (success, message);
    } else {
      return (false, "Serverfehler (${response.statusCode})");
    }
  } catch (e) {
    return (false, "Verbindungsfehler: $e");
  }
}
