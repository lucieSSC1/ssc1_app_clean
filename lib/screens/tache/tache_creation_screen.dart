/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/tache/tache_creation_screen.dart
   DESCRIPTION : Création d’une tâche (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/tache_api.dart';
import '../../models/tache_model.dart';

class TacheCreationScreen extends StatefulWidget {
  final int lotId;

  const TacheCreationScreen({super.key, required this.lotId});

  @override
  State<TacheCreationScreen> createState() => _TacheCreationScreenState();
}

class _TacheCreationScreenState extends State<TacheCreationScreen> {
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController nomCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  bool statut = false;

  Future<void> save() async {
    final tache = TacheModel(
      id: 0, // ignoré par l’API
      code: codeCtrl.text,
      nom: nomCtrl.text,
      description: descCtrl.text,
      statut: statut,
      lotId: widget.lotId,
    );

    await TacheApi.insertTache(tache);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle tâche"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Code"),
            ),
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Checkbox(
                  value: statut,
                  onChanged: (v) {
                    setState(() {
                      statut = v ?? false;
                    });
                  },
                ),
                const Text("Statut complété"),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}