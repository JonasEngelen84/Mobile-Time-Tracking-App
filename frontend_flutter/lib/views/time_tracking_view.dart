import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/time_tracking_api.dart';

/// Hauptansicht nach Login — Zeiterfassung (Start / Stopp / manuelle Eingabe)
/// Wichtige Design-Entscheidung:
/// - UI bleibt "dumm" (zeigt nur Status, sendet Events an API)
/// - Alle zeitlichen Berechnungen, Validierungen und Persistenz erledigt das Backend (TimeTrackingApi)
/// - In dieser View nur Darstellung, Picker und das Weiterleiten der gewählten Werte
class TimeTrackingView extends StatefulWidget {
  final String username;           // authentifizierter Benutzername
  final VoidCallback onLogout;     // Callback zum Abmelden
  final VoidCallback onShowOverview; // Callback zur Übersicht (Liste von Einträgen)

  const TimeTrackingView({
    Key? key,
    required this.username,
    required this.onLogout,
    required this.onShowOverview,
  }) : super(key: key);

  @override
  State<TimeTrackingView> createState() => _TimeTrackingViewState();
}

class _TimeTrackingViewState extends State<TimeTrackingView> {
  // --- Formatierung wie im Backend (time_services.py erwartet %d.%m.%Y %H:%M) ---
  final DateFormat _dateTimeFormatter = DateFormat('dd.MM.yyyy HH:mm');

  // --- UI / State Variablen ---
  // Aktivitätenliste (gleich zur Tkinter-Liste)
  final List<String> _activities = [
    "Arbeit mit Klient",
    "Betreuungskind krank",
    "Dienstreise",
    "Dokumentation",
    "Fortbildung",
    "Interne Planung",
    "Eigenes Kind krank",
    "Krank",
    "Pause",
    "Sonstige bezahlt",
    "Sonstige unbezahlt",
    "Teammeeting",
    "Urlaub",
    "Zeitausgleich"
  ];

  String _selectedActivity = "Arbeit mit Klient"; // aktuell gewählte Aktivität
  String _statusMessage = "";   // Status-/Fehlermeldung vom Backend (message)
  String _durationText = "Dauer: 0 Minuten"; // Anzeige der letzten Dauermeldung (falls vom Backend geliefert)

  // Für die manuelle Eingabe: formattierte Strings im Backend-Format oder null falls nicht gewählt
  String? _startTimeFormatted;
  String? _stopTimeFormatted;

  // --- Hilfsfunktionen ---

  /// Öffnet zuerst einen DatePicker, dann einen TimePicker und liefert ein
  /// formatiertes Datum/Zeit-String zurück (oder null, falls abgebrochen).
  Future<String?> _selectDateTimeAsFormattedString() async {
    // Datum wählen
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Datum wählen',
    );

    if (pickedDate == null) return null; // Benutzer hat abgebrochen

    // Uhrzeit wählen
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Uhrzeit wählen',
    );

    if (pickedTime == null) return null; // Benutzer hat abgebrochen

    // Kombinieren und formatieren wie Backend erwartet
    final DateTime combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    return _dateTimeFormatter.format(combined);
  }

  // --- API-Aufrufe (delegieren an TimeTrackingApi) ---
  // Hinweis: TimeTrackingApi liefert Map<String, dynamic> { "success": bool, "message": String, optional "duration": String }

  /// Start-Button: signalisiert dem Backend, dass eine Aktivität begonnen wurde.
  /// UI zeigt die vom Backend zurückgegebene Nachricht (message).
  Future<void> _startTimer() async {
    final Map<String, dynamic> result = await TimeTrackingApi.startTimer(
      username: widget.username,
      activity: _selectedActivity,
    );

    // Statusmeldung anzeigen, Dauer zurücksetzen (Start liefert in der Regel keine Dauer)
    setState(() {
      _statusMessage = (result["message"] ?? "").toString();
      _durationText = "Dauer: 0 Minuten";
    });
  }

  /// Stop-Button: signalisiert dem Backend, die aktuelle Aktivität zu beenden.
  /// Backend sollte Dauer berechnen und in `result["duration"]` oder `result["message"]` zurückliefern.
  Future<void> _stopTimer() async {
    final Map<String, dynamic> result = await TimeTrackingApi.stopTimer(
      username: widget.username,
    );

    // Ergebnis verarbeiten: message immer anzeigen, duration optional nutzen
    setState(() {
      _statusMessage = (result["message"] ?? "").toString();

      // Falls Backend eine separate duration liefert, priorisieren wir diese für die Anzeige
      final dynamic dur = result["duration"];
      if (dur != null) {
        _durationText = dur.toString();
      } else if (result["success"] == true) {
        // wenn kein duration-Feld, aber success = true, kann message die Dauer enthalten
        _durationText = (result["message"] ?? "").toString();
      } else {
        // bei Fehler die Dauer nicht ändern
      }
    });
  }

  /// Manuelle Bestätigung: Start- und Stoppzeit werden als Strings im Backend-Format
  /// übergeben. Backend validiert, speichert, berechnet Dauer und liefert message zurück.
  Future<void> _confirmManualEntry() async {
    // Validierung auf UI-Ebene: beide Zeiten müssen gewählt sein (Backend prüft tiefer)
    if (_startTimeFormatted == null || _stopTimeFormatted == null) {
      setState(() {
        _statusMessage = "❌ Bitte Start- und Stoppzeit wählen.";
      });
      return;
    }

    final Map<String, dynamic> result = await TimeTrackingApi.submitManualEntry(
      username: widget.username,
      activity: _selectedActivity,
      start: _startTimeFormatted!,
      stop: _stopTimeFormatted!,
    );

    setState(() {
      _statusMessage = (result["message"] ?? "").toString();

      // Falls Backend eine duration-Feld zurückliefert, zeige es explizit an
      final dynamic dur = result["duration"];
      if (dur != null) {
        _durationText = dur.toString();
      } else if (result["success"] == true) {
        // fallback: falls API nur message hat, verwenden wir message als Daueranzeige
        _durationText = (result["message"] ?? "").toString();
      }
    });
  }

  // --- Widget-Build (UI) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zeiterfassung'),
        actions: [
          // Optional: direkter Logout-Button in AppBar (weiterleitet an provided callback)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Abmelden',
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Aktivitäts-Auswahl (Dropdown) ---
            const Text("Aktivität auswählen:", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedActivity,
              isExpanded: true,
              items: _activities.map((act) {
                return DropdownMenuItem<String>(
                  value: act,
                  child: Text(act),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedActivity = val);
                }
              },
            ),
            const SizedBox(height: 24),

            // --- START-ROW: Start-API (links) + DateTime-Picker-Feld (rechts) ---
            Row(
              children: [
                // Start-Button (ruft backend-start)
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Start"),
                ),
                const SizedBox(width: 12),

                // Anzeige / Picker für die Start-Zeit (öffnet Date+Time Picker beim Tippen)
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final formatted = await _selectDateTimeAsFormattedString();
                      if (formatted != null) {
                        setState(() => _startTimeFormatted = formatted);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _startTimeFormatted ?? 'Startzeit wählen (optional)',
                        style: TextStyle(
                          color: _startTimeFormatted == null ? Colors.grey.shade600 : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Dauer-Anzeige (zentral) ---
            Center(
              child: Text(
                _durationText,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            const SizedBox(height: 16),

            // --- STOP-ROW: Stop-API (links) + DateTime-Picker-Feld (rechts) ---
            Row(
              children: [
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Stopp"),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final formatted = await _selectDateTimeAsFormattedString();
                      if (formatted != null) {
                        setState(() => _stopTimeFormatted = formatted);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _stopTimeFormatted ?? 'Stoppzeit wählen (optional)',
                        style: TextStyle(
                          color: _stopTimeFormatted == null ? Colors.grey.shade600 : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Manuelle Bestätigung (nutzt die oben gewählten Start/Stop) ---
            ElevatedButton(
              onPressed: _confirmManualEntry,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: const Text("Manuelle Bestätigung"),
            ),

            const SizedBox(height: 12),

            // --- Übersicht öffnen (Callback an MainView) ---
            ElevatedButton(
              onPressed: widget.onShowOverview,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: const Text("Übersicht öffnen"),
            ),

            const SizedBox(height: 12),

            // --- Logout (Callback an MainView) ---
            OutlinedButton(
              onPressed: widget.onLogout,
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
              child: const Text("Logout"),
            ),

            const SizedBox(height: 20),

            // --- Statusmeldung vom Backend (Fehler / Erfolgsmeldung) ---
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _statusMessage.startsWith('❌') ? Colors.red : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}