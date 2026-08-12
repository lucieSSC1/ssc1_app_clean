/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/projet/definition_projet_screen.dart
   DESCRIPTION : Menu Définition du projet (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../lot/lot_list_screen.dart';

class DefinitionProjetScreen extends StatelessWidget {
  final int projetId;

  const DefinitionProjetScreen({super.key, required this.projetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Définition du projet"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // LOTS
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LotListScreen(projetId: projetId),
                ),
              );
            },
            child: const Text("Lots"),
          ),

          const SizedBox(height: 20),

          // Tâches, activités, journées viendront plus tard
        ],
      ),
    );
  }
}