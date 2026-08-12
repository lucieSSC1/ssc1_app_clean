/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/planification/planification_add_screen.dart
   STRUCTURE 4 — Ajouter une planification

   Logique :
     - Une planification est une activité mise dans la liste de travail.
     - On doit fournir :
         activ_id
         activ_code
         activ_nom
         description (optionnelle)
         terminee = false

   Cet écran est appelé depuis :
     ACTIVITÉ ? bouton "Planifier"
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/planification_api.dart';
import '../../models/planification_model.dart';

class PlanificationAddScreen extends StatefulWidget {
  final int activId;
  final String activCode;
  final String activNom;

  const PlanificationAddScreen({
    super.key,
    required this.activId,
    required this.activCode,
    required this.activNom,
  });

  @override
  State<PlanificationAddScreen> createState() => _PlanificationAddScreenState();
}

class _PlanificationAddScreenState extends State<PlanificationAddScreen> {
  final TextEditingController descriptionCtrl = TextEditingController();
  bool saving = false;

  Future<void> enregistrer() async {
    setState(() => saving = true);

    final planif = PlanificationModel(
      id: 0, // sera ignoré par l'API
      activId: widget.activId,
      activCode: widget.activCode,
      activNom: widget.activNom,
      description: descriptionCtrl.text.trim().isEmpty
          ? null
          : descriptionCtrl.text.trim(),
      terminee: false,
    );

    await PlanificationApi.createPlanification(planif);

    setState(() => saving = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une planification"),
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
              "${widget.activCode} — ${widget.activNom}",
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