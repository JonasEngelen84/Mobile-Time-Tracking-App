import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;
  final void Function(String activity) onStart;
  final void Function() onStop;
  final void Function(String start, String stop, String activity) onManualConfirm;
  final VoidCallback onShowOverview;

  const MainView({
    Key? key,
    required this.username,
    required this.onLogout,
    required this.onStart,
    required this.onStop,
    required this.onManualConfirm,
    required this.onShowOverview,
  }) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<String> _aktivitaeten = [
    "Arbeit mit Klient", "Betreuungskind krank", "Dienstreise", "Dokumentation",
    "Fortbildung", "Interne Planung", "Eigenes Kind krank", "Krank", "Pause",
    "Sonstige bezahlt", "Sonstige unbezahlt", "Teammeeting", "Urlaub", "Zeitausgleich"
  ];

  String _selectedActivity = "Arbeit mit Klient";
  String _durationText = "Dauer: 0 Minuten";

  final TextEditingController _startController = TextEditingController(text: "DD.MM.YYYY HH:MM");
  final TextEditingController _stopController = TextEditingController(text: "DD.MM.YYYY HH:MM");

  void _handleFocus(TextEditingController controller, bool hasFocus) {
    if (hasFocus && controller.text == "DD.MM.YYYY HH:MM") {
      controller.clear();
    } else if (!hasFocus && controller.text.isEmpty) {
      controller.text = "DD.MM.YYYY HH:MM";
    }
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
              items: _aktivitaeten.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => _selectedActivity = val!),
              isExpanded: true,
            ),

            const SizedBox(height: 24),
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
                  child: Focus(
                    onFocusChange: (hasFocus) => _handleFocus(_startController, hasFocus),
                    child: TextField(
                      controller: _startController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Text(_durationText, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),
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
                  child: Focus(
                    onFocusChange: (hasFocus) => _handleFocus(_stopController, hasFocus),
                    child: TextField(
                      controller: _stopController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onManualConfirm(
                  _startController.text.trim(),
                  _stopController.text.trim(),
                  _selectedActivity,
                );
              },
              child: const Text("Manuelle Bestätigung"),
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onShowOverview,
              child: const Text("Übersicht öffnen"),
            ),

            const SizedBox(height: 12),
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
