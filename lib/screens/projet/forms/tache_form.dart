// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/forms/tache_form.dart
// -----------------------------------------------------------------------------
// Formulaire d’ajout / modification d’une Tâche
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../../models/tache_model.dart';

class TacheForm extends StatefulWidget {
  final TacheModel? tache;
  final int lotId;

  const TacheForm({super.key, this.tache, required this.lotId});

  @override
  State<TacheForm> createState() => _TacheFormState();
}

class _TacheFormState extends State<TacheForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeCtrl;
  late TextEditingController _nomCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();

    _codeCtrl = TextEditingController(text: widget.tache?.code ?? "");
    _nomCtrl = TextEditingController(text: widget.tache?.nom ?? "");
    _descCtrl = TextEditingController(text: widget.tache?.description ?? "");
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nomCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tache == null ? "Ajouter une tâche" : "Modifier la tâche"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeCtrl,
                decoration: const InputDecoration(labelText: "Code"),
                validator: (v) => v == null || v.isEmpty ? "Code obligatoire" : null,
              ),
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) => v == null || v.isEmpty ? "Nom obligatoire" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final tache = TacheModel(
                id: widget.tache?.id ?? 0,
                code: _codeCtrl.text,
                nom: _nomCtrl.text,
                description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
                statut: widget.tache?.statut ?? false,
                lotId: widget.lotId,
              );
              Navigator.pop(context, tache);
            }
          },
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}