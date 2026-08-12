/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/lot/lot_creation_screen.dart
   DESCRIPTION : Création d’un lot (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/lot_api.dart';
import '../../models/lot_model.dart';

class LotCreationScreen extends StatefulWidget {
  final int projetId;

  const LotCreationScreen({super.key, required this.projetId});

  @override
  State<LotCreationScreen> createState() => _LotCreationScreenState();
}

class _LotCreationScreenState extends State<LotCreationScreen> {
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController nomCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  bool statut = false;

  Future<void> save() async {
    final lot = LotModel(
      id: 0, // ignoré par l’API
      code: codeCtrl.text,
      nom: nomCtrl.text,
      description: descCtrl.text,
      statut: statut,
      projId: widget.projetId,
    );

    await LotApi.insertLot(lot);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouveau lot"),
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