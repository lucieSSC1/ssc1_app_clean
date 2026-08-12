/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/planification/planification_edit_screen.dart
   STRUCTURE 4 — Modifier une planification

   Permet de modifier :
     - description
     - statut "terminée"

   Appelé depuis :
     planification_list_screen.dart
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/planification_api.dart';
import '../../models/planification_model.dart';

class PlanificationEditScreen extends StatefulWidget {
  final PlanificationModel planif;

  const PlanificationEditScreen({
    super.key,
    required this.planif,
  });

  @override
  State<PlanificationEditScreen> createState() =>
      _PlanificationEditScreenState();
}

class _PlanificationEditScreenState extends State<PlanificationEditScreen> {
  late TextEditingController descriptionCtrl;
  late bool terminee;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    descriptionCtrl = TextEditingController(text: widget.planif.description);
    terminee = widget.planif.terminee;
  }

  Future<void> enregistrer() async {
    setState(() => saving = true);

    final updated = PlanificationModel(
      id: widget.planif.id,
      activId: widget.planif.activId,
      activCode: widget.planif.activCode,
      activNom: widget.planif.activNom,
      description: descriptionCtrl.text.trim().isEmpty
          ? null
          : descriptionCtrl.text.trim(),
      terminee: terminee,
    );

    await PlanificationApi.updatePlanification(updated);

    setState(() => saving = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier la planification"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------------------
            // Informations sur l'activité
            // -------------------------------------------------------------
            Text(
              "${widget.planif.activCode} — ${widget.planif.activNom}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------------
            // Description
            // -------------------------------------------------------------
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descriptionCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Notes ou détails de la planification",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------------
            // Terminé
            // -------------------------------------------------------------
            Row(
              children: [
                const Text(
                  "Terminée",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                Switch(
                  value: terminee,
                  onChanged: (v) => setState(() => terminee = v),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // -------------------------------------------------------------
            // Bouton Enregistrer
            // -------------------------------------------------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saving ? null : enregistrer,
                child: saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Enregistrer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}