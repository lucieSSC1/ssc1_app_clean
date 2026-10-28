// ============================================================
// FICHIER : lib/screens/biographie/dialogs/recherche_categorie_dialog.dart
// Fenêtre compacte SSC1 — Recherche par catégorie (300x300)
// ============================================================

import 'package:flutter/material.dart';
import '../../../models/event_categ_model.dart';

class RechercheCategorieDialog extends StatefulWidget {
  final List<EventCateg> categories;
  final Function(int) onSearch;

  const RechercheCategorieDialog({
    super.key,
    required this.categories,
    required this.onSearch,
  });

  @override
  State<RechercheCategorieDialog> createState() =>
      _RechercheCategorieDialogState();
}

class _RechercheCategorieDialogState extends State<RechercheCategorieDialog> {
  int? _cat;

  Future<void> _popup(String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false, // ⭐ Correction
      builder: (_) => AlertDialog(
        title: const Text("Recherche"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
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
              const Text(
                "Recherche par catégorie",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Catégorie",
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                value: _cat,
                items: widget.categories
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.nom)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _cat = v),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text("Rechercher"),
                    onPressed: () async {
                      if (_cat == null) {
                        await _popup("Choisir une catégorie.");
                        return;
                      }
                      widget.onSearch(_cat!);
                      Navigator.pop(context);
                    },
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
