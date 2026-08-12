/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/tache/tache_modification_screen.dart
   DESCRIPTION : Modification d’une tâche (Structure 4)
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/tache_api.dart';
import '../../models/tache_model.dart';

class TacheModificationScreen extends StatefulWidget {
  final TacheModel tache;

  const TacheModificationScreen({super.key, required this.tache});

  @override
  State<TacheModificationScreen> createState() => _TacheModificationScreenState();
}

class _TacheModificationScreenState extends State<TacheModificationScreen> {
  late TextEditingController codeCtrl;
  late TextEditingController nomCtrl;
  late TextEditingController descCtrl;

  bool statut = false;

  @override
  void initState() {
    super.initState();

    codeCtrl = TextEditingController(text: widget.tache.code);
    nomCtrl = TextEditingController(text: widget.tache.nom);
    descCtrl = TextEditingController(text: widget.tache.description);
    statut = widget.tache.statut;
  }

  Future<void> save() async {
    final updated = TacheModel(
      id: widget.tache.id,
      code: codeCtrl.text,
      nom: nomCtrl.text,
      description: descCtrl.text,
      statut: statut,
      lotId: widget.tache.lotId,
    );

    await TacheApi.updateTache(updated);

    if (!mounted) return;
    Navigator.pop(context); // retour à la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier la tâche"),
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