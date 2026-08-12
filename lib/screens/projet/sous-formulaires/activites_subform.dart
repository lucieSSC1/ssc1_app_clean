// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/activites_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire des Activités d’une tâche (CRUD complet + API)
// Ajout : Bouton PLANIFIER (Structure 2 ? Structure 4)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/activite_model.dart';
import '../../../api/activite_api.dart';
import '../forms/activite_form.dart';

// AJOUTS PLANIFICATION
import '../../../models/planification_model.dart';
import '../../../api/planification_api.dart';
import 'planification_subform.dart';

class ActivitesSubform extends StatefulWidget {
  final dynamic tache; // TacheModel

  const ActivitesSubform({super.key, required this.tache});

  @override
  State<ActivitesSubform> createState() => _ActivitesSubformState();
}

class _ActivitesSubformState extends State<ActivitesSubform> {
  List<ActiviteModel> _activites = [];
  ActiviteModel? _activiteSelectionnee;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerActivites();
  }

  // ---------------------------------------------------------------------------
  // CHARGEMENT DES ACTIVITÉS (API réelle)
  // ---------------------------------------------------------------------------
  Future<void> _chargerActivites() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      _activites = await ActiviteApi.getActivites(widget.tache.id);

      if (_activites.isEmpty) {
        _activiteSelectionnee = null;
      } else if (_activiteSelectionnee != null) {
        _activiteSelectionnee = _activites.firstWhere(
          (a) => a.id == _activiteSelectionnee!.id,
          orElse: () => _activites.first,
        );
      }
    } catch (e) {
      _erreur = "Impossible de charger les activités.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  Future<void> _ajouterActivite() async {
    final result = await showDialog<ActiviteModel>(
      context: context,
      builder: (_) => ActiviteForm(
        tacheId: widget.tache.id,
      ),
    );

    if (result != null) {
      await ActiviteApi.createActivite(result);
      await _chargerActivites();
    }
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  Future<void> _modifierActivite() async {
    if (_activiteSelectionnee == null) return;

    final result = await showDialog<ActiviteModel>(
      context: context,
      builder: (_) => ActiviteForm(
        activite: _activiteSelectionnee,
        tacheId: widget.tache.id,
      ),
    );

    if (result != null) {
      await ActiviteApi.updateActivite(result);
      await _chargerActivites();
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  Future<void> _supprimerActivite() async {
    if (_activiteSelectionnee == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text(
            "Supprimer l’activité « ${_activiteSelectionnee!.nom} » ?"),
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
      await ActiviteApi.deleteActivite(_activiteSelectionnee!.id);
      _activiteSelectionnee = null;
      await _chargerActivites();
    }
  }

  // ---------------------------------------------------------------------------
  // PLANIFIER UNE ACTIVITÉ (Structure 2)
  // ---------------------------------------------------------------------------
  Future<void> _planifierActivite() async {
    if (_activiteSelectionnee == null) return;

    final a = _activiteSelectionnee!;

    // Création de l'objet planification
    final planif = PlanificationModel(
      id: 0,
      projId: widget.tache.projetId,
      activId: a.id,
      activCode: a.code,
      activNom: a.nom,
      description: a.description,
      terminee: false,
    );

    // Enregistrement API
    await PlanificationApi.createPlanification(planif);

    // Ouvrir la fenêtre Planification
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlanificationSubform(
          projetId: widget.tache.projetId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Activités de : ${widget.tache.code} ${widget.tache.nom}"),
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

            if (_activiteSelectionnee != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text(
                  "Activité sélectionnée : "
                  "${_activiteSelectionnee!.code} "
                  "${_activiteSelectionnee!.nom}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

            // LISTE DES ACTIVITÉS
            Expanded(
              child: ListView.builder(
                itemCount: _activites.length,
                itemBuilder: (context, index) {
                  final activite = _activites[index];

                  return Card(
                    child: ListTile(
                      selected: _activiteSelectionnee?.id == activite.id,
                      title: Text("${activite.code} ${activite.nom}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (activite.description != null &&
                              activite.description!.isNotEmpty)
                            Text(activite.description!),
                          if (activite.duree != null)
                            Text("Durée : ${activite.duree} h"),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _activiteSelectionnee = activite;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // BOUTONS CRUD + PLANIFIER
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _ajouterActivite,
                    child: const Text("Ajouter"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _activiteSelectionnee == null ? null : _modifierActivite,
                    child: const Text("Modifier"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _activiteSelectionnee == null ? null : _supprimerActivite,
                    child: const Text("Supprimer"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // BOUTON PLANIFIER
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _activiteSelectionnee == null ? null : _planifierActivite,
                child: const Text("Planifier"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}