// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/sous_formulaires/ressources_subform.dart
// -----------------------------------------------------------------------------
// Sous-formulaire Ressources (CRUD complet)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../../models/ressource_model.dart';
import '../../../api/ressource_api.dart';
import '../forms/ressource_form.dart';

class RessourcesSubform extends StatefulWidget {
  const RessourcesSubform({super.key});

  @override
  State<RessourcesSubform> createState() => _RessourcesSubformState();
}

class _RessourcesSubformState extends State<RessourcesSubform> {
  List<RessourceModel> _ressources = [];
  RessourceModel? _selection;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      _ressources = await RessourceApi.getRessources();
    } catch (e) {
      _erreur = "Erreur lors du chargement des ressources.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  Future<void> _ajouter() async {
    final r = await Navigator.push<RessourceModel>(
      context,
      MaterialPageRoute(
        builder: (_) => const RessourceForm(),
      ),
    );

    if (r != null) {
      await RessourceApi.createRessource(r);
      await _charger();
    }
  }

  Future<void> _modifier() async {
    if (_selection == null) return;

    final r = await Navigator.push<RessourceModel>(
      context,
      MaterialPageRoute(
        builder: (_) => RessourceForm(ressource: _selection),
      ),
    );

    if (r != null) {
      await RessourceApi.updateRessource(r);
      await _charger();
    }
  }

  Future<void> _supprimer() async {
    if (_selection == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: Text("Supprimer la ressource « ${_selection!.nom} » ?"),
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
      await RessourceApi.deleteRessource(_selection!.id);
      _selection = null;
      await _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ressources"),
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
                itemCount: _ressources.length,
                itemBuilder: (context, index) {
                  final r = _ressources[index];

                  return Card(
                    child: ListTile(
                      selected: _selection?.id == r.id,
                      title: Text(r.nom),
                      subtitle: r.compagnie != null
                          ? Text(r.compagnie!)
                          : null,
                      onTap: () {
                        setState(() {
                          _selection = r;
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
                    onPressed: _ajouter,
                    child: const Text("Ajouter"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selection == null ? null : _modifier,
                    child: const Text("Modifier"),
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