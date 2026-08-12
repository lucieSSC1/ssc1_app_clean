// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/activite/activite_screen.dart
// -----------------------------------------------------------------------------
// Liste des activités d’un projet
// Boutons : Ajouter, Modifier, Supprimer
// Boutons intégrés : JOURNÉE + DÉTAIL (travail effectué)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../api/activite_api.dart';
import '../../models/activite_model.dart';

import '../journee/journee_screen.dart';
import '../journee/journee_detail_screen.dart';

class ActiviteScreen extends StatefulWidget {
  final int projetId;
  final String projetNom;

  const ActiviteScreen({
    super.key,
    required this.projetId,
    required this.projetNom,
  });

  @override
  State<ActiviteScreen> createState() => _ActiviteScreenState();
}

class _ActiviteScreenState extends State<ActiviteScreen> {
  List<ActiviteModel> _items = [];
  ActiviteModel? _selection;

  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ---------------------------------------------------------------------------
  // CHARGER LES ACTIVITÉS
  // ---------------------------------------------------------------------------
  Future<void> _charger() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      final data =
          await ActiviteApi.getActivitesParProjet(widget.projetId);

      data.sort((a, b) => b.id.compareTo(a.id));

      setState(() {
        _items = data;
      });
    } catch (e) {
      setState(() {
        _erreur = "Erreur lors du chargement des activités.";
      });
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // OUVRIR JOURNÉE
  // ---------------------------------------------------------------------------
  Future<void> _ouvrirJournee(ActiviteModel a) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JourneeScreen(
          activiteId: a.id,
          activiteNom: a.activiteNom,
        ),
      ),
    );

    await _charger();
  }

  // ---------------------------------------------------------------------------
  // OUVRIR DÉTAIL DU TRAVAIL EFFECTUÉ
  // ---------------------------------------------------------------------------
  Future<void> _ouvrirDetail(ActiviteModel a) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JourneeDetailScreen(
          activiteId: a.id,
          activiteNom: a.activiteNom,
        ),
      ),
    );
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
          "Supprimer l’activité « ${_selection!.activiteNom} » ?",
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
      await ActiviteApi.deleteActivite(_selection!.id);
      _selection = null;
      await _charger();
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activités — ${widget.projetNom}"),
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
                  final a = _items[index];

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      selected: _selection?.id == a.id,

                      title: Text("${a.code} — ${a.activiteNom}"),
                      subtitle: Text(a.description ?? "(Aucune description)"),

                      onTap: () {
                        setState(() {
                          _selection = a;
                        });
                      },

                      // -----------------------------------------------------------------
                      // BOUTONS JOURNÉE + DÉTAIL
                      // -----------------------------------------------------------------
                      trailing: SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _ouvrirJournee(a),
                              child: const Text("Journée"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _ouvrirDetail(a),
                              child: const Text("Détail"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // -----------------------------------------------------------------
            // BOUTONS : Ajouter / Modifier / Supprimer
            // -----------------------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ton écran d’ajout/modification d’activité
                      // (non demandé ici)
                    },
                    child: const Text("Ajouter"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _selection == null ? null : () {
                          // Ton écran de modification
                        },
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