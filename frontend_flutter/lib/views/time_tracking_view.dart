import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTrackingView extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;
  final void Function(String activity) onStart;
  final void Function() onStop;
  final void Function(String start, String stop, String activity) onManualConfirm;
  final VoidCallback onShowOverview;

  const TimeTrackingView({
    Key? key,
    required this.username,
    required this.onLogout,
    required this.onStart,
    required this.onStop,
    required this.onManualConfirm,
    required this.onShowOverview,
  }) : super(key: key);

  @override
  State<TimeTrackingView> createState() => _TimeTrackingViewState();
}

class _TimeTrackingViewState extends State<TimeTrackingView> {
  final List<String> _activities = [
    "Arbeit mit Klient", "Betreuungskind krank", "Dienstreise", "Dokumentation",
    "Fortbildung", "Interne Planung", "Eigenes Kind krank", "Krank", "Pause",
    "Sonstige bezahlt", "Sonstige unbezahlt", "Teammeeting", "Urlaub", "Zeitausgleich"
  ];

  String _selectedActivity = "Arbeit mit Klient";
  String _durationText = "Dauer: 0 Minuten";

  DateTime? _startTime;
  DateTime? _stopTime;

  final DateFormat _formatter = DateFormat("dd.MM.yyyy HH:mm");

  /// Öffnet einen kombinierten Date- und TimePicker, gibt ein DateTime-Objekt zurück.
  Future<DateTime?> _selectDateTime(BuildContext context) async {
    // Zuerst Datum wählen
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    // Danach Uhrzeit wählen
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  /// Berechnet die Dauer zwischen Start und Stopp (falls beide gesetzt)
  void _calculateDuration() {
    if (_startTime != null && _stopTime != null) {
      final duration = _stopTime!.difference(_startTime!);
      setState(() {
        _durationText = "Dauer: ${duration.inMinutes} Minuten";
      });
    }
  }

  /// Formatiert ein Datum, falls vorhanden, sonst Platzhalter
  String _formatOrPlaceholder(DateTime? dt) {
    return dt != null ? _formatter.format(dt) : "Datum & Uhrzeit wählen";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zeiterfassung")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text("Aktivität auswählen:", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedActivity,
              items: _activities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedActivity = val!),
              isExpanded: true,
            ),

            const SizedBox(height: 24),

            /// Startzeit auswählen
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onStart(_selectedActivity);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Start"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final selected = await _selectDateTime(context);
                      if (selected != null) {
                        setState(() => _startTime = selected);
                        _calculateDuration();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatOrPlaceholder(_startTime)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(_durationText, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            /// Stoppzeit auswählen
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onStop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Stopp"),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final selected = await _selectDateTime(context);
                      if (selected != null) {
                        setState(() => _stopTime = selected);
                        _calculateDuration();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(_formatOrPlaceholder(_stopTime)),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Manuelle Bestätigung
            ElevatedButton(
              onPressed: () {
                if (_startTime != null && _stopTime != null) {
                  widget.onManualConfirm(
                    _formatter.format(_startTime!),
                    _formatter.format(_stopTime!),
                    _selectedActivity,
                  );
                }
              },
              child: const Text("Manuelle Bestätigung"),
            ),

            const SizedBox(height: 12),

            /// Übersicht anzeigen
            ElevatedButton(
              onPressed: widget.onShowOverview,
              child: const Text("Übersicht öffnen"),
            ),

            const SizedBox(height: 12),

            /// Logout
            OutlinedButton(
              onPressed: widget.onLogout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
