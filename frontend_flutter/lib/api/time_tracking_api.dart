import 'dart:convert';
import 'package:http/http.dart' as http;

/// API-Klasse für Zeiterfassung
class TimeTrackingApi {
  static const String baseUrl = "http://10.0.2.2:5000";

  /// Startet den Timer im Backend.
  /// Gibt eine Map zurück: { "success": bool, "message": String }
  static Future<Map<String, dynamic>> startTimer({
    required String username,
    required String activity,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/start_timer");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "activity": activity,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"],
          "message": data["message"] ?? "",
        };
      } else {
        return {
          "success": false,
          "message": "Serverfehler (${response.statusCode}) beim Starten.",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Netzwerkfehler: $e",
      };
    }
  }

  /// Stoppt den Timer im Backend.
  /// Gibt eine Map zurück: { "success": bool, "message": String }
  static Future<Map<String, dynamic>> stopTimer({
    required String username,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/stop_timer");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"],
          "message": data["message"] ?? "",
        };
      } else {
        return {
          "success": false,
          "message": "Serverfehler (${response.statusCode}) beim Stoppen.",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Netzwerkfehler: $e",
      };
    }
  }

  /// Sendet einen manuellen Zeiteintrag.
  /// Gibt eine Map zurück: { "success": bool, "message": String }
  static Future<Map<String, dynamic>> submitManualEntry({
    required String username,
    required String activity,
    required String start,
    required String stop,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/manual_entry");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "activity": activity,
          "start": start,
          "stop": stop,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"],
          "message": data["message"] ?? "",
        };
      } else {
        return {
          "success": false,
          "message": "Serverfehler (${response.statusCode}) bei manueller Eingabe.",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Netzwerkfehler: $e",
      };
    }
  }
}
