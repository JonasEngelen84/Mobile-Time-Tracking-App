/// Modellklasse zur Darstellung eines Zeiterfassungs-Eintrags.
/// Wird für die Anzeige, Verarbeitung und Übergabe von Zeitdaten verwendet.
class TimeEntry {
  final DateTime start;      // Startzeitpunkt
  final DateTime stop;       // Stoppzeitpunkt
  final String activity;     // Beschreibung der Tätigkeit

  TimeEntry({
    required this.start,
    required this.stop,
    required this.activity,
  });

  /// Berechnet die Dauer zwischen Start und Stopp.
  Duration get duration => stop.difference(start);

  /// Konstruktor zur Erstellung aus einer Map (z. B. JSON vom Backend).
  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      start: DateTime.parse(json['start']),
      stop: DateTime.parse(json['stop']),
      activity: json['activity'],
    );
  }

  /// Wandelt das Objekt in eine Map um (z. B. für API-Requests).
  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'stop': stop.toIso8601String(),
      'activity': activity,
    };
  }
}
