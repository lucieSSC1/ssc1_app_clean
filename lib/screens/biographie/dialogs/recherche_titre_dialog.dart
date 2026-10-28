// ============================================================
// FICHIER : lib/screens/biographie/dialogs/recherche_titre_dialog.dart
// Fenêtre compacte SSC1 — Recherche par titre (NON‑dismissible)
// ============================================================

import 'package:flutter/material.dart';

class RechercheTitreDialog extends StatefulWidget {
  final Function(String) onSearch;

  const RechercheTitreDialog({super.key, required this.onSearch});

  @override
  State<RechercheTitreDialog> createState() => _RechercheTitreDialogState();
}

class _RechercheTitreDialogState extends State<RechercheTitreDialog> {
  final _ctrl = TextEditingController();

  Future<void> _valider() async {
    final titre = _ctrl.text.trim();

    if (titre.isEmpty) {
      await showDialog(
        context: context,
        barrierDismissible: false, // ⭐ Correction
        builder: (_) => AlertDialog(
          title: const Text("Recherche"),
          content: const Text("Entrer un titre."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    widget.onSearch(titre);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Recherche par titre", style: TextStyle(fontSize: 18)),

              const SizedBox(height: 20),

              TextField(
                controller: _ctrl,
                decoration: const InputDecoration(
                  labelText: "Titre",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text("Rechercher"),
                    onPressed: _valider,
                  ),
                  ElevatedButton(
                    child: const Text("Annuler"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
