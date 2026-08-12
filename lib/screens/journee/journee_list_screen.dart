/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/journee/journee_list_screen.dart
   DESCRIPTION :
   Liste des journées d’une activité (Structure 4)
   ORDRE demandé :
   En-tête :
     projetId / nomProjet / activ_id / code_activité / nom_activité / heures planifiées
   Lignes :
     date / heures travaillées / description
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/journee_api.dart';
import '../../models/journee_model.dart';

import 'journee_creation_screen.dart';
import 'journee_modification_screen.dart';

class JourneeListScreen extends StatefulWidget {
  final int projetId;
  final String nomProjet;

  final int activiteId;
  final String codeActivite;
  final String nomActivite;
  final double heuresPlanifiees;

  const JourneeListScreen({
    super.key,
    required this.projetId,
    required this.nomProjet,
    required this.activiteId,
    required this.codeActivite,
    required this.nomActivite,
    required this.heuresPlanifiees,
  });

  @override
  State<JourneeListScreen> createState() => _JourneeListScreenState();
}

class _JourneeListScreenState extends State<JourneeListScreen> {
  late Future<List<JourneeModel>> futureJournees;

  @override
  void initState() {
    super.initState();
    futureJournees = JourneeApi.getJourneesParActivite(widget.activiteId);
  }

  void refresh() {
    setState(() {
      futureJournees = JourneeApi.getJourneesParActivite(widget.activiteId);
    });
  }

  double calculerTotal(List<JourneeModel> j) {
    return j.fold(0, (sum, e) => sum + e.heuresTravaillees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journées de l’activité"),
      ),

      body: FutureBuilder<List<JourneeModel>>(
        future: futureJournees,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final journees = snapshot.data!;
          final totalHeures = calculerTotal(journees);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------------------------------------------------
              // EN-TÊTE COMPLET (ordre exact demandé)
              // -------------------------------------------------------------
              Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Projet #${widget.projetId} — ${widget.nomProjet}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 6),

                    Text("Activité #${widget.activiteId}",
                        style: const TextStyle(fontSize: 15)),

                    Text("Code activité : ${widget.codeActivite}",
                        style: const TextStyle(fontSize: 15)),

                    Text("Nom activité : ${widget.nomActivite}",
                        style: const TextStyle(fontSize: 15)),

                    Text(
                      "Heures planifiées : ${widget.heuresPlanifiees.toStringAsFixed(1)} h",
                      style: const TextStyle(fontSize: 15),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Total heures travaillées : ${totalHeures.toStringAsFixed(1)} h",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // -------------------------------------------------------------
              // LISTE DES JOURNÉES (ordre exact demandé)
              // -------------------------------------------------------------
              Expanded(
                child: ListView.builder(
                  itemCount: journees.length,
                  itemBuilder: (context, index) {
                    final j = journees[index];

                    return Card(
                      child: ListTile(
                        title: Text("${j.date} — ${j.heuresTravaillees} h"),
                        subtitle: Text(
                          "Description : ${j.description ?? ""}",
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // MODIFIER
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        JourneeModificationScreen(journee: j),
                                  ),
                                );
                                refresh();
                              },
                            ),

                            // SUPPRIMER
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await JourneeApi.deleteJournee(j.id);
                                refresh();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // -------------------------------------------------------------
      // BOUTON AJOUTER
      // -------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JourneeCreationScreen(
                activiteId: widget.activiteId,
              ),
            ),
          );
          refresh();
        },
      ),
    );
  }
}