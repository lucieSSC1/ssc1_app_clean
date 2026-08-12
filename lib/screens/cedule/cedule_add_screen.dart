/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/cedule/cedule_add_screen.dart
   STRUCTURE 4 — Ajouter une cédule

   Une cédule représente un engagement réel :
     - activité (id, code, nom)
     - date (DD-MM-YYYY)
     - durée planifiée (ex: "1.5")
     - statut "terminée" = false

   Appelé depuis :
     PLANIFICATION ? bouton "Céduler"
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/cedule_api.dart';
import '../../models/cedule_model.dart';

class CeduleAddScreen extends StatefulWidget {
  final int activId;
  final String activCode;
  final String activNom;

  const CeduleAddScreen({
    super.key,
    required this.activId,
    required this.activCode,
    required this.activNom,
  });

  @override
  State<CeduleAddScreen> createState() => _CeduleAddScreenState();
}

class _CeduleAddScreenState extends State<CeduleAddScreen> {
  final TextEditingController dateCtrl = TextEditingController();
  final TextEditingController dureeCtrl = TextEditingController();

  bool saving = false;

  Future<void> enregistrer() async {
    if (dateCtrl.text.trim().isEmpty || dureeCtrl.text.trim().isEmpty) {
      return;
    }

    setState(() => saving = true);

    final cedule = CeduleModel(
      id: 0, // ignoré par l'API
      activId: widget.activId,
      activCode: widget.activCode,
      activNom: widget.activNom,
      date: dateCtrl.text.trim(),
      dureePlanifiee: dureeCtrl.text.trim(),
      terminee: false,
    );

    await CeduleApi.createCedule(cedule);

    setState(() => saving = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une cédule"),
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
            // Date
            // -------------------------------------------------------------
            const Text(
              "Date (DD-MM-YYYY)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(
                hintText: "Ex : 12-06-2026",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------------
            // Durée planifiée
            // -------------------------------------------------------------
            const Text(
              "Durée planifiée (heures)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: dureeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Ex : 1.5",
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