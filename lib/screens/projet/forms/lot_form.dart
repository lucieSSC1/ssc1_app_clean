// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/forms/lot_form.dart
// -----------------------------------------------------------------------------
// Formulaire d’ajout / modification d’un Lot
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../../models/lot_model.dart';

class LotForm extends StatefulWidget {
  final LotModel? lot;
  final int projetId;

  const LotForm({super.key, this.lot, required this.projetId});

  @override
  State<LotForm> createState() => _LotFormState();
}

class _LotFormState extends State<LotForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeCtrl;
  late TextEditingController _nomCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();

    _codeCtrl = TextEditingController(text: widget.lot?.code ?? "");
    _nomCtrl = TextEditingController(text: widget.lot?.nom ?? "");
    _descCtrl = TextEditingController(text: widget.lot?.description ?? "");
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
      title: Text(widget.lot == null ? "Ajouter un lot" : "Modifier le lot"),
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
              final lot = LotModel(
                id: widget.lot?.id ?? 0,
                code: _codeCtrl.text,
                nom: _nomCtrl.text,
                description: _descCtrl.text.isEmpty ? null : _descCtrl.text,
                statut: widget.lot?.statut ?? false,
                projId: widget.projetId,
              );
              Navigator.pop(context, lot);
            }
          },
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}