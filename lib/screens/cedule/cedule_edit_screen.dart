/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/cedule/cedule_edit_screen.dart
   STRUCTURE 4 — Modifier une cédule

   Permet de modifier :
     - date (DD-MM-YYYY)
     - durée planifiée (ex: "1.5")
     - statut "terminée"

   Appelé depuis :
     cedule_list_screen.dart
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/cedule_api.dart';
import '../../models/cedule_model.dart';

class CeduleEditScreen extends StatefulWidget {
  final CeduleModel cedule;

  const CeduleEditScreen({
    super.key,
    required this.cedule,
  });

  @override
  State<CeduleEditScreen> createState() => _CeduleEditScreenState();
}

class _CeduleEditScreenState extends State<CeduleEditScreen> {
  late TextEditingController dateCtrl;
  late TextEditingController dureeCtrl;
  late bool terminee;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    dateCtrl = TextEditingController(text: widget.cedule.date);
    dureeCtrl = TextEditingController(text: widget.cedule.dureePlanifiee);
    terminee = widget.cedule.terminee;
  }

  Future<void> enregistrer() async {
    if (dateCtrl.text.trim().isEmpty || dureeCtrl.text.trim().isEmpty) {
      return;
    }

    setState(() => saving = true);

    final updated = CeduleModel(
      id: widget.cedule.id,
      activId: widget.cedule.activId,
      activCode: widget.cedule.activCode,
      activNom: widget.cedule.activNom,
      date: dateCtrl.text.trim(),
      dureePlanifiee: dureeCtrl.text.trim(),
      terminee: terminee,
    );

    await CeduleApi.updateCedule(updated);

    setState(() => saving = false);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier la cédule"),
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
              "${widget.cedule.activCode} — ${widget.cedule.activNom}",
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