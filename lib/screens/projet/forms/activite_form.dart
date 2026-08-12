// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/forms/activite_form.dart
// -----------------------------------------------------------------------------
// Formulaire d’ajout / modification d’une Activité
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../../models/activite_model.dart';

class ActiviteForm extends StatefulWidget {
  final ActiviteModel? activite;
  final int tacheId;

  const ActiviteForm({super.key, this.activite, required this.tacheId});

  @override
  State<ActiviteForm> createState() => _ActiviteFormState();
}

class _ActiviteFormState extends State<ActiviteForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codeCtrl;
  late TextEditingController _nomCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _dureeCtrl;

  @override
  void initState() {
    super.initState();

    _codeCtrl = TextEditingController(text: widget.activite?.code ?? "");
    _nomCtrl = TextEditingController(text: widget.activite?.nom ?? "");
    _descCtrl = TextEditingController(text: widget.activite?.description ?? "");
    _dureeCtrl = TextEditingController(
      text: widget.activite?.duree?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nomCtrl.dispose();
    _descCtrl.dispose();
    _dureeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.activite == null
          ? "Ajouter une activité"
          : "Modifier l’activité"),
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
                validator: (v) =>
                    v == null || v.isEmpty ? "Code obligatoire" : null,
              ),
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Nom obligatoire" : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _dureeCtrl,
                decoration:
                    const InputDecoration(labelText: "Durée (heures)"),
                keyboardType: TextInputType.number,
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
              final activite = ActiviteModel(
                id: widget.activite?.id ?? 0,
                code: _codeCtrl.text,
                nom: _nomCtrl.text,
                description:
                    _descCtrl.text.isEmpty ? null : _descCtrl.text,
                duree: _dureeCtrl.text.isEmpty
                    ? null
                    : double.tryParse(_dureeCtrl.text),
                tacheId: widget.tacheId,
                respId: widget.activite?.respId,
              );
              Navigator.pop(context, activite);
            }
          },
          child: const Text("Enregistrer"),
        ),
      ],
    );
  }
}