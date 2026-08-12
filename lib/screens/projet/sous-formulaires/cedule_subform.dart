// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/cedule_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire Cédule (Structure 4)
// Amélioration visuelle + bouton Statistiques multiprojet
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/cedule_model.dart';
import '../../../api/cedule_api.dart';
import '../../statistiques/statistiques_multiprojet_screen.dart';

class CeduleSubform extends StatefulWidget {
  final int activiteId;

  const CeduleSubform({
    super.key,
    required this.activiteId,
  });

  @override
  State<CeduleSubform> createState() => _CeduleSubformState();
}

class _CeduleSubformState extends State<CeduleSubform> {
  List<CeduleModel> _items = [];
  CeduleModel? _selection;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ---------------------------------------------------------------------------
  // CHARGER TOUTES LES CÉDULES
  // ---------------------------------------------------------------------------
  Future<void> _charger() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      final all = await CeduleApi.getCedules();

      // Toutes les cédules, triées du plus récent au plus ancien
      all.sort((a, b) => b.id.compareTo(a.id));
      _items = all;
    } catch (e) {
      _erreur = "Erreur lors du chargement des cédules.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER
  // ---------------------------------------------------------------------------
  Future<void> _supprimer() async {
    if (_selection == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text(
          "Supprimer la cédule du ${_selection!.date} (${_selection!.dureePlanifiee} h) ?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await CeduleApi.deleteCedule(_selection!.id);
      _selection = null;
      await _charger();
    }
  }

  // ---------------------------------------------------------------------------
  // TERMINER / DÉTERMINER
  // ---------------------------------------------------------------------------
  Future<void> _toggleTerminee() async {
    if (_selection == null) return;

    final c = CeduleModel(
      id: _selection!.id,
      activId: _selection!.activId,
      activCode: _selection!.activCode,
      activNom: _selection!.activNom,
      date: _selection!.date,
      dureePlanifiee: _selection!.dureePlanifiee,
      terminee: !_selection!.terminee,
    );

    await CeduleApi.updateCedule(c);
    await _charger();
  }

  // ---------------------------------------------------------------------------
  // OUVRIR STATISTIQUES MULTIPROJET
  // ---------------------------------------------------------------------------
  Future<void> _ouvrirStatistiques() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const StatistiquesMultiprojetScreen(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cédule"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            if (_chargement) const LinearProgressIndicator(),

            if (_erreur != null)
              Text(
                _erreur!,
                style: const TextStyle(color: Colors.red),
              ),

            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final c = _items[index];

                  final styleActivite = TextStyle(
                    fontWeight: FontWeight.bold,
                    color: c.terminee ? Colors.blue : Colors.black,
                  );

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      selected: _selection?.id == c.id,

                      title: Text(
                        "${c.activCode} — ${c.activNom}",
                        style: styleActivite,
                      ),

                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "Date : ${c.date}\nDurée : ${c.dureePlanifiee} h",
                        ),
                      ),

                      onTap: () {
                        setState(() {
                          _selection = c;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // -----------------------------------------------------------------
            // BOUTON STATISTIQUES MULTIPROJET
            // -----------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _ouvrirStatistiques,
                child: const Text("Statistiques multiprojet"),
              ),
            ),

            const SizedBox(height: 8),

            // -----------------------------------------------------------------
            // BOUTONS TERMINER / SUPPRIMER
            // -----------------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selection == null ? null : _toggleTerminee,
                    child: Text(
                      _selection?.terminee == true
                          ? "Déterminer"
                          : "Terminer",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selection == null ? null : _supprimer,
                    child: const Text("Supprimer"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}