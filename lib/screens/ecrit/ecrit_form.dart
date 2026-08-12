// ssc1_app/lib/screens/ecrit/ecrit_form.dart
//
// Formulaire : Écrit (module Loisir - SSC1)
// -----------------------------------------
// Permet de créer ou modifier un écrit.
// Correspond EXACTEMENT à la table SQL "ecrit".
//
// Champs SQL :
// - titre
// - type
// - auteur
// - texte_url
// - notes

import 'package:flutter/material.dart';

import '../../models/ecrit_model.dart';
import '../../services/ecrit_service.dart';

class EcritForm extends StatefulWidget {
  final Ecrit? ecrit;

  const EcritForm({super.key, this.ecrit});

  @override
  State<EcritForm> createState() => _EcritFormState();
}

class _EcritFormState extends State<EcritForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreCtrl = TextEditingController();
  final _auteurCtrl = TextEditingController();
  final _texteUrlCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _type;

  final _service = EcritService();

  // Liste de types (modifiable selon ton usage)
  final List<String> _types = [
    "poème",
    "texte",
    "histoire",
    "citation",
    "autre",
  ];

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final e = widget.ecrit;
    if (e == null) return;

    _titreCtrl.text = e.titre ?? "";
    _type = e.type;
    _auteurCtrl.text = e.auteur ?? "";
    _texteUrlCtrl.text = e.texteUrl ?? "";
    _notesCtrl.text = e.notes ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ecrit = Ecrit(
      id: widget.ecrit?.id,
      titre: _titreCtrl.text,
      type: _type,
      auteur: _auteurCtrl.text,
      texteUrl: _texteUrlCtrl.text,
      notes: _notesCtrl.text,
    );

    if (widget.ecrit == null) {
      await _service.create(ecrit);
    } else {
      await _service.update(ecrit);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.ecrit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier écrit" : "Nouvel écrit"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Titre", _titreCtrl, required: true),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _type,
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _type = v),
                decoration: const InputDecoration(
                  labelText: "Type",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ? "Veuillez choisir un type" : null,
              ),

              const SizedBox(height: 16),
              _field("Auteur", _auteurCtrl),

              _field("URL du texte (Word)", _texteUrlCtrl),

              _field("Notes", _notesCtrl, maxLines: 3),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? "Enregistrer" : "Créer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool required = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        validator: required
            ? (v) => (v == null || v.isEmpty) ? "Champ requis" : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}