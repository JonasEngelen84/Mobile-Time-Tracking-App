import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sendet Anmeldedaten an das Backend und verarbeitet die Antwort.
///
/// Gibt eine Map zurück:
/// {
///   "success": true/false,
///   "message": "Erfolgsmeldung oder Fehlerbeschreibung"
/// }
Future<Map<String, dynamic>> loginUser(String username, String password) async {
  try {
    // Backend-Endpunkt
    final url = Uri.parse("http://10.0.2.2:5000/api/auth/login");

    // Daten als JSON senden
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
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
        "message": "Serverfehler (${response.statusCode}) bei der Anmeldung.",
      };
    }
  } catch (e) {
    return {
      "success": false,
      "message": "Netzwerkfehler: $e",
    };
  }
}
