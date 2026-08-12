// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/planification_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire Planification (Structure 2 corrigée)
// Liste des planifications + Supprimer + Terminer + Céduler
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/planification_model.dart';
import '../../../api/planification_api.dart';
import 'cedule_subform.dart';

class PlanificationSubform extends StatefulWidget {
  final int projetId;

  const PlanificationSubform({
    super.key,
    required this.projetId,
  });

  @override
  State<PlanificationSubform> createState() => _PlanificationSubformState();
}

class _PlanificationSubformState extends State<PlanificationSubform> {
  List<PlanificationModel> _items = [];
  PlanificationModel? _selection;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ---------------------------------------------------------------------------
  // CHARGER
  // ---------------------------------------------------------------------------
  Future<void> _charger() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      final all = await PlanificationApi.getPlanifications();

      // filtrer par projet
      _items = all.where((p) => p.projId == widget.projetId).toList();
    } catch (e) {
      _erreur = "Erreur lors du chargement des planifications.";
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
          "Supprimer la planification de « ${_selection!.activCode} ${_selection!.activNom} » ?",
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
      await PlanificationApi.deletePlanification(_selection!.id);
      _selection = null;
      await _charger();
    }
  }

  // ---------------------------------------------------------------------------
  // TERMINER / DÉTERMINER
  // ---------------------------------------------------------------------------
  Future<void> _toggleTerminee() async {
    if (_selection == null) return;

    final p = PlanificationModel(
      id: _selection!.id,
      projId: _selection!.projId,
      activId: _selection!.activId,
      activCode: _selection!.activCode,
      activNom: _selection!.activNom,
      description: _selection!.description,
      terminee: !_selection!.terminee,
    );

    await PlanificationApi.updatePlanification(p);
    await _charger();
  }

  // ---------------------------------------------------------------------------
  // CÉDULER
  // ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// CÉDULER (ouvre cedule_subform.dart)
// ---------------------------------------------------------------------------
Future<void> _ceduler() async {
  if (_selection == null) return;

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CeduleSubform(
        activiteId: _selection!.activId,
      ),
    ),
  );

  // Après fermeture de la cédule ? recharger la planification
  await _charger();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planification"),
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
                  final p = _items[index];

                  return Card(
                    child: ListTile(
                      selected: _selection?.id == p.id,
                      title: Text("${p.activCode} — ${p.activNom}"),
                      subtitle: p.description != null
                          ? Text(p.description!)
                          : null,
                      trailing: p.terminee
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.radio_button_unchecked),
                      onTap: () {
                        setState(() {
                          _selection = p;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

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
                    onPressed: _selection == null ? null : _ceduler,
                    child: const Text("Céduler"),
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