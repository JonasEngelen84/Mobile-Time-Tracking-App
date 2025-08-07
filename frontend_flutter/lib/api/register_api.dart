import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sendet Registrierungsdaten an das Backend und verarbeitet die Antwort.
///
/// Gibt eine Map zurück:
/// {
///   "success": true/false,
///   "message": "Erfolgsmeldung oder Fehlerbeschreibung"
/// }
Future<Map<String, dynamic>> registerUser(
    String username, String password, String passwordRepeat) async {
  try {
    // Backend-Endpunkt
    final url = Uri.parse("http://10.0.2.2:5000/register");

    // Daten als JSON senden
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "password_repetition": passwordRepeat,
      }),
    );

    // Antwort auswerten
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "success": data["success"],
        "message": data["message"],
      };
    } else {
      return {
        "success": false,
        "message": "Serverfehler (${response.statusCode}) bei der Registrierung.",
      };
    }
  } catch (e) {
    return {
      "success": false,
      "message": "Netzwerkfehler: $e",
    };
  }
}
