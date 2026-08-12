/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/journee/journee_modification_screen.dart
   DESCRIPTION : Modification d’une journée (Structure 4)
   Ordre des champs : date, heures, objectif, description, suite, note
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/journee_api.dart';
import '../../models/journee_model.dart';

class JourneeModificationScreen extends StatefulWidget {
  final JourneeModel journee;

  const JourneeModificationScreen({
    super.key,
    required this.journee,
  });

  @override
  State<JourneeModificationScreen> createState() =>
      _JourneeModificationScreenState();
}

class _JourneeModificationScreenState
    extends State<JourneeModificationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController dateCtrl;
  late TextEditingController heuresCtrl;
  late TextEditingController objectifCtrl;
  late TextEditingController descriptionCtrl;
  late TextEditingController suiteCtrl;
  late TextEditingController noteCtrl;

  bool chargement = false;

  @override
  void initState() {
    super.initState();

    final j = widget.journee;

    dateCtrl = TextEditingController(text: j.date);
    heuresCtrl = TextEditingController(text: j.heuresTravaillees.toString());
    objectifCtrl = TextEditingController(text: j.objectif ?? "");
    descriptionCtrl = TextEditingController(text: j.description ?? "");
    suiteCtrl = TextEditingController(text: j.suite ?? "");
    noteCtrl = TextEditingController(text: j.note ?? "");
  }

  // ---------------------------------------------------------------------------
  // ENREGISTRER
  // ---------------------------------------------------------------------------
  Future<void> enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => chargement = true);

    final j = JourneeModel(
      id: widget.journee.id,
      activId: widget.journee.activId,
      date: dateCtrl.text.trim(),
      heuresTravaillees:
          double.tryParse(heuresCtrl.text.trim()) ?? 0,
      objectif: objectifCtrl.text.trim(),
      description: descriptionCtrl.text.trim(),
      suite: suiteCtrl.text.trim(),
      note: noteCtrl.text.trim(),
    );

    await JourneeApi.updateJournee(j);

    setState(() => chargement = false);

    if (mounted) Navigator.pop(context);
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier journée"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              // DATE
              TextFormField(
                controller: dateCtrl,
                decoration:
                    const InputDecoration(labelText: "Date (JJ-MM-AAAA)"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Date requise" : null,
              ),

              // HEURES TRAVAILLÉES
              TextFormField(
                controller: heuresCtrl,
                decoration:
                    const InputDecoration(labelText: "Heures travaillées"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Heures requises" : null,
              ),

              // OBJECTIF
              TextFormField(
                controller: objectifCtrl,
                decoration: const InputDecoration(labelText: "Objectif"),
                maxLines: 2,
              ),

              // DESCRIPTION
              TextFormField(
                controller: descriptionCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),

              // SUITE
              TextFormField(
                controller: suiteCtrl,
                decoration: const InputDecoration(labelText: "Suite"),
                maxLines: 2,
              ),

              // NOTE
              TextFormField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: "Note"),
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              if (chargement) const LinearProgressIndicator(),

              const SizedBox(height: 20),

              // BOUTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: enregistrer,
                      child: const Text("Enregistrer"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}