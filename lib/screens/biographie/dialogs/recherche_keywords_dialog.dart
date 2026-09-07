// ============================================================
// FICHIER : recherche_keywords_dialog.dart
// Version SSC1 — ET/OU + Recherche exacte/partielle
// ============================================================

import 'package:flutter/material.dart';

class RechercheKeywordsDialog extends StatefulWidget {
  final Function(String, String, String, bool, bool) onSearch;

  const RechercheKeywordsDialog({super.key, required this.onSearch});

  @override
  State<RechercheKeywordsDialog> createState() =>
      _RechercheKeywordsDialogState();
}

class _RechercheKeywordsDialogState extends State<RechercheKeywordsDialog> {
  final _mc1 = TextEditingController();
  final _mc2 = TextEditingController();
  final _mc3 = TextEditingController();

  bool _modeEt = false; // false = OU(*), true = ET( )
  bool _rechercheExacte = false; // false = partielle(*), true = exacte( )

  // ------------------------------------------------------------
  // NORMALISATION
  // ------------------------------------------------------------
  String _normalize(String s) {
    s = s.trim();
    s = s.replaceAll('’', "'");
    s = s.toLowerCase();

    const map = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'å': 'a',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
    };

    s = s.split('').map((c) => map[c] ?? c).join();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    return s;
  }

  // ------------------------------------------------------------
  // VALIDATION + APPEL SERVICE
  // ------------------------------------------------------------
  Future<void> _valider() async {
    String mc1 = _normalize(_mc1.text);
    String mc2 = _normalize(_mc2.text);
    String mc3 = _normalize(_mc3.text);

    if (mc1.isEmpty && mc2.isEmpty && mc3.isEmpty) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Recherche"),
          content: const Text("Entrer au moins un mot‑clé."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    widget.onSearch(mc1, mc2, mc3, _modeEt, _rechercheExacte);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 360, // ⭐ Augmenté pour afficher tous les boutons
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Recherche par mots‑clés",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: _mc1,
                      decoration: const InputDecoration(
                        labelText: "Mot‑clé 1",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _mc2,
                      decoration: const InputDecoration(
                        labelText: "Mot‑clé 2",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 8),

                    TextField(
                      controller: _mc3,
                      decoration: const InputDecoration(
                        labelText: "Mot‑clé 3",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ⭐ ET( )   OU(*)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("ET "),
                        Radio<bool>(
                          value: true,
                          groupValue: _modeEt,
                          onChanged: (v) => setState(() => _modeEt = v!),
                        ),
                        const SizedBox(width: 20),
                        const Text("OU "),
                        Radio<bool>(
                          value: false,
                          groupValue: _modeEt,
                          onChanged: (v) => setState(() => _modeEt = v!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ⭐ Recherche exacte( )   Recherche partielle(*)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Exacte "),
                        Radio<bool>(
                          value: true,
                          groupValue: _rechercheExacte,
                          onChanged: (v) =>
                              setState(() => _rechercheExacte = v!),
                        ),
                        const SizedBox(width: 20),
                        const Text("Partielle "),
                        Radio<bool>(
                          value: false,
                          groupValue: _rechercheExacte,
                          onChanged: (v) =>
                              setState(() => _rechercheExacte = v!),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

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
