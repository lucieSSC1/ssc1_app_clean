// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/taches_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire des Tâches d’un lot (CRUD complet + API)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/tache_model.dart';
import '../../../api/tache_api.dart';
import '../forms/tache_form.dart';
import 'activites_subform.dart';

class TachesSubform extends StatefulWidget {
  final dynamic lot; // LotModel

  const TachesSubform({super.key, required this.lot});

  @override
  State<TachesSubform> createState() => _TachesSubformState();
}

class _TachesSubformState extends State<TachesSubform> {
  List<TacheModel> _taches = [];
  TacheModel? _tacheSelectionnee;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerTaches();
  }

  // ---------------------------------------------------------------------------
  // CHARGEMENT DES TÂCHES (API réelle)
  // ---------------------------------------------------------------------------
  Future<void> _chargerTaches() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      _taches = await TacheApi.getTaches(widget.lot.id);

      if (_taches.isEmpty) {
        _tacheSelectionnee = null;
      } else if (_tacheSelectionnee != null) {
        _tacheSelectionnee = _taches.firstWhere(
          (t) => t.id == _tacheSelectionnee!.id,
          orElse: () => _taches.first,
        );
      }
    } catch (e) {
      _erreur = "Impossible de charger les tâches.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UNE TÂCHE
  // ---------------------------------------------------------------------------
  Future<void> _ajouterTache() async {
    final result = await showDialog<TacheModel>(
      context: context,
      builder: (_) => TacheForm(
        lotId: widget.lot.id,
      ),
    );

    if (result != null) {
      await TacheApi.createTache(result);
      await _chargerTaches();
    }
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UNE TÂCHE
  // ---------------------------------------------------------------------------
  Future<void> _modifierTache() async {
    if (_tacheSelectionnee == null) return;

    final result = await showDialog<TacheModel>(
      context: context,
      builder: (_) => TacheForm(
        tache: _tacheSelectionnee,
        lotId: widget.lot.id,
      ),
    );

    if (result != null) {
      await TacheApi.updateTache(result);
      await _chargerTaches();
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UNE TÂCHE
  // ---------------------------------------------------------------------------
  Future<void> _supprimerTache() async {
    if (_tacheSelectionnee == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text("Supprimer la tâche « ${_tacheSelectionnee!.nom} » ?"),
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
      await TacheApi.deleteTache(_tacheSelectionnee!.id);
      _tacheSelectionnee = null;
      await _chargerTaches();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tâches du lot : ${widget.lot.code} ${widget.lot.nom}"),
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

            if (_tacheSelectionnee != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(
                  "Tâche sélectionnée : ${_tacheSelectionnee!.code} ${_tacheSelectionnee!.nom}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            // LISTE DES TÂCHES
            Expanded(
              child: ListView.builder(
                itemCount: _taches.length,
                itemBuilder: (context, index) {
                  final tache = _taches[index];

                  return Card(
                    child: ListTile(
                      selected: _tacheSelectionnee?.id == tache.id,
                      title: Text("${tache.code} ${tache.nom}"),
                      subtitle: tache.description != null && tache.description!.isNotEmpty
                          ? Text(tache.description!)
                          : null,
                      onTap: () {
                        setState(() {
                          _tacheSelectionnee = tache;
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
                    onPressed: _ajouterTache,
                    child: const Text("Ajouter"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _tacheSelectionnee == null ? null : _modifierTache,
                    child: const Text("Modifier"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _tacheSelectionnee == null ? null : _supprimerTache,
                    child: const Text("Supprimer"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // BOUTON ACTIVITÉS
            ElevatedButton(
              onPressed: _tacheSelectionnee == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ActivitesSubform(
                            tache: _tacheSelectionnee!,
                          ),
                        ),
                      );
                    },
              child: const Text("Activités de la tâche"),
            ),
          ],
        ),
      ),
    );
  }
}