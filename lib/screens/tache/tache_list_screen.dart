/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/tache/tache_list_screen.dart
   DESCRIPTION : Liste des tâches d’un lot (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/tache_api.dart';
import '../../models/tache_model.dart';
import 'tache_creation_screen.dart';
import 'tache_modification_screen.dart';

class TacheListScreen extends StatefulWidget {
  final int lotId;

  const TacheListScreen({super.key, required this.lotId});

  @override
  State<TacheListScreen> createState() => _TacheListScreenState();
}

class _TacheListScreenState extends State<TacheListScreen> {
  late Future<List<TacheModel>> futureTaches;

  @override
  void initState() {
    super.initState();
    futureTaches = TacheApi.getTachesByLot(widget.lotId);
  }

  void refresh() {
    setState(() {
      futureTaches = TacheApi.getTachesByLot(widget.lotId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tâches du lot"),
      ),
      body: FutureBuilder<List<TacheModel>>(
        future: futureTaches,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final taches = snapshot.data!;

          if (taches.isEmpty) {
            return const Center(
              child: Text("Aucune tâche pour ce lot."),
            );
          }

          return ListView.builder(
            itemCount: taches.length,
            itemBuilder: (context, index) {
              final t = taches[index];

              return Card(
                child: ListTile(
                  title: Text(t.nom ?? "(Sans nom)"),
                  subtitle: Text(t.code ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modifier
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TacheModificationScreen(tache: t),
                            ),
                          );
                          refresh();
                        },
                      ),

                      // Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await TacheApi.deleteTache(t.id);
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

      // Bouton Ajouter
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TacheCreationScreen(lotId: widget.lotId),
            ),
          );
          refresh();
        },
      ),
    );
  }
}