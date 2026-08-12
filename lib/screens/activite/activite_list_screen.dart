/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/activite/activite_list_screen.dart
   STRUCTURE 4 — Liste des activités d'une tâche

   Affiche :
     - code activité
     - nom activité
     - heures planifiées
     - heures travaillées (calculées)
     - description (optionnelle)

   Actions :
     - Planifier
     - Détail (Journées)
     - Modifier
     - Supprimer
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/activite_api.dart';
import '../../models/activite_model.dart';

import '../planification/planification_add_screen.dart';
import '../activite/activite_detail_screen.dart';
import '../activite/activite_edit_screen.dart';

class ActiviteListScreen extends StatefulWidget {
  final int tacheId;
  final String tacheNom;

  const ActiviteListScreen({
    super.key,
    required this.tacheId,
    required this.tacheNom,
  });

  @override
  State<ActiviteListScreen> createState() => _ActiviteListScreenState();
}

class _ActiviteListScreenState extends State<ActiviteListScreen> {
  List<ActiviteModel> liste = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    setState(() => loading = true);

    liste = await ActiviteApi.getActivitesParTache(widget.tacheId);

    setState(() => loading = false);
  }

  Future<void> supprimer(int id) async {
    await ActiviteApi.deleteActivite(id);
    charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activités — ${widget.tacheNom}"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : liste.isEmpty
              ? const Center(child: Text("Aucune activité."))
              : ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    final a = liste[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text("${a.code} — ${a.nom}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (a.description != null &&
                                a.description!.trim().isNotEmpty)
                              Text(a.description!),

                            const SizedBox(height: 4),

                            Text(
                              "Planifiées : ${a.heuresPlanifiees} h   |   Travaillées : ${a.heuresTravaillees} h",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                        // -----------------------------------------------------------------
                        // BOUTONS À DROITE
                        // -----------------------------------------------------------------
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // -------------------------------------------------------------
                            // BOUTON PLANIFIER
                            // -------------------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.playlist_add),
                              tooltip: "Planifier",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlanificationAddScreen(
                                      activId: a.id,
                                      activCode: a.code,
                                      activNom: a.nom,
                                    ),
                                  ),
                                ).then((_) => charger());
                              },
                            ),

                            // -------------------------------------------------------------
                            // BOUTON DÉTAIL (Journées)
                            // -------------------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              tooltip: "Détail",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActiviteDetailScreen(
                                      activiteId: a.id,
                                      code: a.code,
                                      nom: a.nom,
                                      description: a.description,
                                      heuresPlanifiees: a.heuresPlanifiees,
                                    ),
                                  ),
                                );
                              },
                            ),

                            // -------------------------------------------------------------
                            // BOUTON MODIFIER
                            // -------------------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: "Modifier",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ActiviteEditScreen(activite: a),
                                  ),
                                ).then((_) => charger());
                              },
                            ),

                            // -------------------------------------------------------------
                            // BOUTON SUPPRIMER
                            // -------------------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Supprimer",
                              onPressed: () => supprimer(a.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}