import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';

/// Übersicht der erfassten Zeit-Einträge
class TimeTrackingOverviewView extends StatelessWidget {
  final List<TimeEntry> entries; // Liste der übergebenen Zeit-Einträge
  final VoidCallback onBack;     // Rücksprung-Callback zur Hauptansicht

  const TimeTrackingOverviewView({
    super.key,
    required this.entries,
    required this.onBack,
  });

  /// Datumsformatierer für die Anzeige von Start/Stopp-Zeiten
  String _formatDate(DateTime dt) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }

  /// Formatiert die Dauer eines Eintrags als „x Min / y Std“
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    final hours = d.inHours;
    return "$minutes Min ($hours Std)";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Übersicht der Einträge')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: entries.isEmpty
                  ? const Center(child: Text("Noch keine Einträge vorhanden."))
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(entry.activity),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Start: ${_formatDate(entry.start)}"),
                                Text("Stopp: ${_formatDate(entry.stop)}"),
                                Text("Dauer: ${_formatDuration(entry.duration)}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onBack,
              child: const Text("Zurück zur Zeiterfassung"),
            ),
          ],
        ),
      ),
    );
  }
}
