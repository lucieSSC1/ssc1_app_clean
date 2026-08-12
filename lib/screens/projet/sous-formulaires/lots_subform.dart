// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/lots_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire des Lots d’un projet (CRUD complet + API)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/lot_model.dart';
import '../../../api/lot_api.dart';
import '../forms/lot_form.dart';
import 'taches_subform.dart';

class LotsSubform extends StatefulWidget {
  final int projetId;

  const LotsSubform({super.key, required this.projetId});

  @override
  State<LotsSubform> createState() => _LotsSubformState();
}

class _LotsSubformState extends State<LotsSubform> {
  List<LotModel> _lots = [];
  LotModel? _lotSelectionne;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerLots();
  }

  // ---------------------------------------------------------------------------
  // CHARGEMENT DES LOTS (API réelle)
  // ---------------------------------------------------------------------------
  Future<void> _chargerLots() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      _lots = await LotApi.getLots(widget.projetId);
      if (_lots.isEmpty) {
        _lotSelectionne = null;
      } else if (_lotSelectionne != null) {
        // garder la sélection si possible
        _lotSelectionne =
            _lots.firstWhere((l) => l.id == _lotSelectionne!.id, orElse: () => _lots.first);
      }
    } catch (e) {
      _erreur = "Impossible de charger les lots.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UN LOT
  // ---------------------------------------------------------------------------
  Future<void> _ajouterLot() async {
    final result = await showDialog<LotModel>(
      context: context,
      builder: (_) => LotForm(
        projetId: widget.projetId,
      ),
    );

    if (result != null) {
      await LotApi.createLot(result);
      await _chargerLots();
    }
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UN LOT
  // ---------------------------------------------------------------------------
  Future<void> _modifierLot() async {
    if (_lotSelectionne == null) return;

    final result = await showDialog<LotModel>(
      context: context,
      builder: (_) => LotForm(
        lot: _lotSelectionne,
        projetId: widget.projetId,
      ),
    );

    if (result != null) {
      await LotApi.updateLot(result);
      await _chargerLots();
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UN LOT
  // ---------------------------------------------------------------------------
  Future<void> _supprimerLot() async {
    if (_lotSelectionne == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text("Supprimer le lot « ${_lotSelectionne!.nom} » ?"),
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
      await LotApi.deleteLot(_lotSelectionne!.id);
      _lotSelectionne = null;
      await _chargerLots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lots du projet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_chargement) const LinearProgressIndicator(),

            if (_erreur != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _erreur!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            if (_lotSelectionne != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(
                  "Lot sélectionné : ${_lotSelectionne!.code} ${_lotSelectionne!.nom}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            // LISTE DES LOTS
            Expanded(
              child: ListView.builder(
                itemCount: _lots.length,
                itemBuilder: (context, index) {
                  final lot = _lots[index];

                  return Card(
                    child: ListTile(
                      selected: _lotSelectionne?.id == lot.id,
                      title: Text("${lot.code} ${lot.nom}"),
                      subtitle: lot.description != null && lot.description!.isNotEmpty
                          ? Text(lot.description!)
                          : null,
                      onTap: () {
                        setState(() {
                          _lotSelectionne = lot;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // BOUTONS CRUD
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _ajouterLot,
                    child: const Text("Ajouter"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _lotSelectionne == null ? null : _modifierLot,
                    child: const Text("Modifier"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _lotSelectionne == null ? null : _supprimerLot,
                    child: const Text("Supprimer"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // BOUTON TÂCHES DU LOT
            ElevatedButton(
              onPressed: _lotSelectionne == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TachesSubform(
                            lot: _lotSelectionne!,
                          ),
                        ),
                      );
                    },
              child: const Text("Tâches du lot"),
            ),
          ],
        ),
      ),
    );
  }
}