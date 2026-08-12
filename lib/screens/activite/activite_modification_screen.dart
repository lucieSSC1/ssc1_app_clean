/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/activite/activite_modification_screen.dart
   DESCRIPTION : Modification d’une activité (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/activite_api.dart';
import '../../api/journee_api.dart';
import '../../models/activite_model.dart';
import '../../models/journee_model.dart';

class ActiviteModificationScreen extends StatefulWidget {
  final ActiviteModel activite;

  const ActiviteModificationScreen({super.key, required this.activite});

  @override
  State<ActiviteModificationScreen> createState() =>
      _ActiviteModificationScreenState();
}

class _ActiviteModificationScreenState
    extends State<ActiviteModificationScreen> {
  late TextEditingController nomCtrl;
  late TextEditingController descCtrl;
  late TextEditingController dureeCtrl;

  double heuresTravaillees = 0;

  @override
  void initState() {
    super.initState();

    nomCtrl = TextEditingController(text: widget.activite.nom);
    descCtrl = TextEditingController(text: widget.activite.description);
    dureeCtrl = TextEditingController(
        text: widget.activite.duree?.toStringAsFixed(1) ?? "");

    _chargerHeuresTravaillees();
  }

  Future<void> _chargerHeuresTravaillees() async {
    final List<JourneeModel> journees =
        await JourneeApi.getJourneesByActivite(widget.activite.id);

    setState(() {
      heuresTravaillees = journees.fold(
        0,
        (sum, j) => sum + (j.heuresTravaillees ?? 0),
      );
    });
  }

  Future<void> save() async {
    final updated = ActiviteModel(
      id: widget.activite.id,
      code: widget.activite.code, // code non modifiable
      nom: nomCtrl.text,
      description: descCtrl.text,
      duree: dureeCtrl.text.isNotEmpty
          ? double.tryParse(dureeCtrl.text)
          : null,
      tacheId: widget.activite.tacheId,
    );

    await ActiviteApi.updateActivite(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier l’activité"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---------------------------------------------------------------
            // CODE (lecture seule)
            // ---------------------------------------------------------------
            TextField(
              controller: TextEditingController(text: widget.activite.code),
              decoration: const InputDecoration(labelText: "Code (non modifiable)"),
              readOnly: true,
            ),

            // ---------------------------------------------------------------
            // NOM
            // ---------------------------------------------------------------
            TextField(
              controller: nomCtrl,
              decoration: const InputDecoration(labelText: "Nom"),
            ),

            // ---------------------------------------------------------------
            // DESCRIPTION
            // ---------------------------------------------------------------
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------------
            // HEURES TRAVAILLÉES (calculé)
            // ---------------------------------------------------------------
            Text(
              "Heures travaillées : ${heuresTravaillees.toStringAsFixed(1)} h",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // DURÉE PLANIFIÉE
            // ---------------------------------------------------------------
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