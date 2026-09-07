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
                  // ⭐ RECHERCHER (à gauche)
                  ElevatedButton(
                    child: const Text("Rechercher"),
                    onPressed: () {
                      if (_cat != null) {
                        widget.onSearch(_cat!);
                      }
                      Navigator.pop(context);
                    },
                  ),

                  // ⭐ ANNULER (à droite)
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
