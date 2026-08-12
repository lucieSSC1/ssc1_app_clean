/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/lot/lot_modification_screen.dart
   DESCRIPTION : Modification d’un lot (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/lot_api.dart';
import '../../models/lot_model.dart';

class LotModificationScreen extends StatefulWidget {
  final LotModel lot;

  const LotModificationScreen({super.key, required this.lot});

  @override
  State<LotModificationScreen> createState() => _LotModificationScreenState();
}

class _LotModificationScreenState extends State<LotModificationScreen> {
  late TextEditingController codeCtrl;
  late TextEditingController nomCtrl;
  late TextEditingController descCtrl;

  bool statut = false;

  @override
  void initState() {
    super.initState();

    codeCtrl = TextEditingController(text: widget.lot.code);
    nomCtrl = TextEditingController(text: widget.lot.nom);
    descCtrl = TextEditingController(text: widget.lot.description);
    statut = widget.lot.statut;
  }

  Future<void> save() async {
    final updatedLot = LotModel(
      id: widget.lot.id,
      code: codeCtrl.text,
      nom: nomCtrl.text,
      description: descCtrl.text,
      statut: statut,
      projId: widget.lot.projId,
    );

    await LotApi.updateLot(updatedLot);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le lot"),
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