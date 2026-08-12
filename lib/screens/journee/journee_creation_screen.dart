/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/journee/journee_creation_screen.dart
   DESCRIPTION : Création d’une journée (Structure 4)
   Ordre des champs : date, heures, objectif, description, suite, note
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/journee_api.dart';
import '../../models/journee_model.dart';

class JourneeCreationScreen extends StatefulWidget {
  final int activiteId;

  const JourneeCreationScreen({
    super.key,
    required this.activiteId,
  });

  @override
  State<JourneeCreationScreen> createState() => _JourneeCreationScreenState();
}

class _JourneeCreationScreenState extends State<JourneeCreationScreen> {
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController heuresCtrl = TextEditingController();
  final TextEditingController objectifCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController suiteCtrl = TextEditingController();
  final TextEditingController noteCtrl = TextEditingController();

  Future<void> save() async {
    final journee = JourneeModel(
      id: 0, // ignoré par l’API
      activId: widget.activiteId,
      date: dateCtrl.text,
      heuresTravaillees: double.tryParse(heuresCtrl.text) ?? 0,
      objectif: objectifCtrl.text,
      description: descriptionCtrl.text,
      suite: suiteCtrl.text,
      note: noteCtrl.text,
    );

    await JourneeApi.insertJournee(journee);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nouvelle journée"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---------------------------------------------------------------
            // DATE
            // ---------------------------------------------------------------
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(
                labelText: "Date (JJ-MM-AAAA)",
              ),
            ),

            // ---------------------------------------------------------------
            // HEURES TRAVAILLÉES
            // ---------------------------------------------------------------
            TextField(
              controller: heuresCtrl,
              decoration: const InputDecoration(
                labelText: "Heures travaillées",
              ),
              keyboardType: TextInputType.number,
            ),

            // ---------------------------------------------------------------
            // OBJECTIF
            // ---------------------------------------------------------------
            TextField(
              controller: objectifCtrl,
              decoration: const InputDecoration(labelText: "Objectif"),
              maxLines: 2,
            ),

            // ---------------------------------------------------------------
            // DESCRIPTION
            // ---------------------------------------------------------------
            TextField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),

            // ---------------------------------------------------------------
            // SUITE
            // ---------------------------------------------------------------
            TextField(
              controller: suiteCtrl,
              decoration: const InputDecoration(labelText: "Suite"),
              maxLines: 2,
            ),

            // ---------------------------------------------------------------
            // NOTE
            // ---------------------------------------------------------------
            TextField(
              controller: noteCtrl,
              decoration: const InputDecoration(labelText: "Note"),
              maxLines: 2,
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