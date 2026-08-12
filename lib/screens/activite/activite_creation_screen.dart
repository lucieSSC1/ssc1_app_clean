/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/activite/activite_creation_screen.dart
   DESCRIPTION : Création d’une activité (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/activite_api.dart';
import '../../models/activite_model.dart';

class ActiviteCreationScreen extends StatefulWidget {
  final int tacheId;

  const ActiviteCreationScreen({super.key, required this.tacheId});

  @override
  State<ActiviteCreationScreen> createState() => _ActiviteCreationScreenState();
}

class _ActiviteCreationScreenState extends State<ActiviteCreationScreen> {
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController nomCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController dureeCtrl = TextEditingController();

  Future<void> save() async {
    final activite = ActiviteModel(
      id: 0, // ignoré par l’API
      code: codeCtrl.text,
      nom: nomCtrl.text,
      description: descCtrl.text,
      duree: dureeCtrl.text.isNotEmpty
          ? double.tryParse(dureeCtrl.text)
          : null,
      tacheId: widget.tacheId,
    );

    await ActiviteApi.insertActivite(activite);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle activité"),
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
            TextField(
              controller: dureeCtrl,
              decoration: const InputDecoration(
                labelText: "Durée planifiée (heures)",
              ),
              keyboardType: TextInputType.number,
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