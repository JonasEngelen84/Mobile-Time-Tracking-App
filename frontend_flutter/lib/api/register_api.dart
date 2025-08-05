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
Future<(bool, String)> registerUser(String username, String password, String passwordRepeat,) async {
  if (username.isEmpty || password.isEmpty || passwordRepeat.isEmpty) {
    return (false, "Alle Felder müssen ausgefüllt sein.");
  }

  if (password != passwordRepeat) {
    return (false, "Passwörter stimmen nicht überein.");
  }

  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:5000/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "password_repeat": passwordRepeat,
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
