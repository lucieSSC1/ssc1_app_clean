/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/lot/lot_list_screen.dart
   DESCRIPTION : Liste des lots d’un projet (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/lot_api.dart';
import '../../models/lot_model.dart';
import '../tache/tache_list_screen.dart';
import 'lot_creation_screen.dart';
import 'lot_modification_screen.dart';

class LotListScreen extends StatefulWidget {
  final int projetId;

  const LotListScreen({super.key, required this.projetId});

  @override
  State<LotListScreen> createState() => _LotListScreenState();
}

class _LotListScreenState extends State<LotListScreen> {
  late Future<List<LotModel>> futureLots;

  @override
  void initState() {
    super.initState();
    futureLots = LotApi.getLotsByProjet(widget.projetId);
  }

  void refresh() {
    setState(() {
      futureLots = LotApi.getLotsByProjet(widget.projetId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lots du projet"),
      ),
      body: FutureBuilder<List<LotModel>>(
        future: futureLots,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lots = snapshot.data!;

          if (lots.isEmpty) {
            return const Center(
              child: Text("Aucun lot pour ce projet."),
            );
          }

          return ListView.builder(
            itemCount: lots.length,
            itemBuilder: (context, index) {
              final lot = lots[index];

              return Card(
                child: ListTile(
                  title: Text(lot.nom ?? "(Sans nom)"),
                  subtitle: Text(lot.code ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // -------------------------------------------------------
                      // BOUTON TÂCHES
                      // -------------------------------------------------------
                      IconButton(
                        icon: const Icon(Icons.list),
                        tooltip: "Tâches",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TacheListScreen(lotId: lot.id),
                            ),
                          );
                        },
                      ),

                      // -------------------------------------------------------
                      // MODIFIER
                      // -------------------------------------------------------
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LotModificationScreen(lot: lot),
                            ),
                          );
                          refresh();
                        },
                      ),

                      // -------------------------------------------------------
                      // SUPPRIMER
                      // -------------------------------------------------------
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await LotApi.deleteLot(lot.id);
                          refresh();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // -------------------------------------------------------
      // BOUTON AJOUTER
      // -------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LotCreationScreen(projetId: widget.projetId),
            ),
          );
          refresh();
        },
      ),
    );
  }
}