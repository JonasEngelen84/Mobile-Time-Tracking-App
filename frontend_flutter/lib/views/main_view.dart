import 'package:flutter/material.dart';

import '../models/time_entry.dart';
import 'login_view.dart';
import 'register_view.dart';
import 'time_tracking_view.dart';
import 'time_tracking_overview_view.dart';

/// Enum zur klaren Definition der möglichen Ansichten (Views)
enum AppView {
  login,
  register,
  timeTracking,
  overview,
}

/// MainView übernimmt ausschließlich die Navigation zwischen den Views,
/// hält den aktuellen State, wer ist eingeloggt, und reagiert auf Events der Views.
class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // Aktuelle Ansicht (View)
  AppView _currentView = AppView.login;

  // Eingeloggter Benutzername, null wenn nicht eingeloggt
  String? _username;

  // Gespeicherte Zeit-Einträge für die Übersicht (Beispiel)
  final List<TimeEntry> _timeEntries = [];

  // --- Methoden zum View-Wechsel und State-Management ---

  // Nach erfolgreichem Login zur TimeTracking-Ansicht wechseln
  void _handleLoginSuccess(String username) {
    setState(() {
      _username = username;
      _currentView = AppView.timeTracking;
    });
  }

  // Zur Registrierung wechseln
  void _goToRegister() {
    setState(() {
      _currentView = AppView.register;
    });
  }

  // Zurück zur Login-Ansicht wechseln
  void _goToLogin() {
    setState(() {
      _username = null;
      _currentView = AppView.login;
    });
  }

  // Zur TimeTracking-Ansicht wechseln (z.B. von Übersicht)
  void _goToTimeTracking() {
    setState(() {
      _currentView = AppView.timeTracking;
    });
  }

  // Zur Übersicht wechseln
  void _goToOverview() {
    setState(() {
      _currentView = AppView.overview;
    });
  }

  // Beispiel: Neue Zeiterfassung hinzufügen
  void _handleAddTimeEntry(TimeEntry entry) {
    setState(() {
      _timeEntries.add(entry);
    });
  }

  // --- Build-Methode entscheidet, welche View angezeigt wird ---
  @override
  Widget build(BuildContext context) {
    switch (_currentView) {
      case AppView.login:
        return LoginView(
          onLoginSuccess: _handleLoginSuccess,
          onGoToRegister: _goToRegister,
        );
      case AppView.register:
        return RegisterView(
          onRegisterSuccess: _goToLogin, // nach Registrierung zurück zum Login
          onGoToLogin: _goToLogin,
        );
      case AppView.timeTracking:
        return TimeTrackingView(
          username: _username!,
          onLogout: _goToLogin,
          onStart: (activity) {
            // Beispiel: Start-Event - hier könntest du Tracking starten
          },
          onStop: () {
            // Beispiel: Stop-Event
          },
          onManualConfirm: (start, stop, activity) {
            // Zeit-Eintrag erzeugen und hinzufügen
            final startDate = DateTime.tryParse(start);
            final stopDate = DateTime.tryParse(stop);
            if (startDate != null && stopDate != null) {
              _handleAddTimeEntry(TimeEntry(
                start: startDate,
                stop: stopDate,
                activity: activity,
              ));
            }
          },
          onShowOverview: _goToOverview,
        );
      case AppView.overview:
        return TimeTrackingOverviewView(
          entries: _timeEntries,
          onBack: _goToTimeTracking,
        );
    }
  }
}
