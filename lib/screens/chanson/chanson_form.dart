// ssc1_app/lib/screens/chanson/chanson_form.dart
//
// Formulaire : Chanson (module Loisir - SSC1)
// -------------------------------------------
// Permet de créer ou modifier une chanson.
// Correspond EXACTEMENT à la table SQL "chanson".
//
// Champs SQL :
// - titre
// - auteur
// - compositeur
// - interprete
// - paroles_url
// - notes

import 'package:flutter/material.dart';

import '../../models/chanson_model.dart';
import '../../services/chanson_service.dart';

class ChansonForm extends StatefulWidget {
  final Chanson? chanson;

  const ChansonForm({super.key, this.chanson});

  @override
  State<ChansonForm> createState() => _ChansonFormState();
}

class _ChansonFormState extends State<ChansonForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreCtrl = TextEditingController();
  final _auteurCtrl = TextEditingController();
  final _compositeurCtrl = TextEditingController();
  final _interpreteCtrl = TextEditingController();
  final _parolesUrlCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final _service = ChansonService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final c = widget.chanson;
    if (c == null) return;

    _titreCtrl.text = c.titre ?? "";
    _auteurCtrl.text = c.auteur ?? "";
    _compositeurCtrl.text = c.compositeur ?? "";
    _interpreteCtrl.text = c.interprete ?? "";
    _parolesUrlCtrl.text = c.parolesUrl ?? "";
    _notesCtrl.text = c.notes ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final chanson = Chanson(
      id: widget.chanson?.id,
      titre: _titreCtrl.text,
      auteur: _auteurCtrl.text,
      compositeur: _compositeurCtrl.text,
      interprete: _interpreteCtrl.text,
      parolesUrl: _parolesUrlCtrl.text,
      notes: _notesCtrl.text,
    );

    if (widget.chanson == null) {
      await _service.create(chanson);
    } else {
      await _service.update(chanson);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.chanson != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier chanson" : "Nouvelle chanson"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Titre", _titreCtrl, required: true),
              _field("Auteur", _auteurCtrl),
              _field("Compositeur", _compositeurCtrl),
              _field("Interprète", _interpreteCtrl),
              _field("URL des paroles (Word)", _parolesUrlCtrl),
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