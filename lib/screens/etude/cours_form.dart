// ssc1_app/lib/screens/etudes/cours_form.dart
//
// Formulaire : Cours (version SSC1)
// ---------------------------------
// Permet de créer ou modifier un cours.
// Correspond EXACTEMENT à la table SQL "cours".
//
// Champs :
// - glob_id
// - code
// - nom
// - desc
// - prog_id
// - session
// - note_num
// - note_alpha
// - categ
// - remarque
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/cours_model.dart';
import '../../services/cours_service.dart';

class CoursForm extends StatefulWidget {
  final Cours? cours;

  const CoursForm({super.key, this.cours});

  @override
  State<CoursForm> createState() => _CoursFormState();
}

class _CoursFormState extends State<CoursForm> {
  final _formKey = GlobalKey<FormState>();

  final _globIdCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _progIdCtrl = TextEditingController();
  final _sessionCtrl = TextEditingController();
  final _noteNumCtrl = TextEditingController();
  final _noteAlphaCtrl = TextEditingController();
  final _categCtrl = TextEditingController();
  final _remarqueCtrl = TextEditingController();

  final _service = CoursService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final c = widget.cours;
    if (c == null) return;

    _globIdCtrl.text = c.globId?.toString() ?? "";
    _codeCtrl.text = c.code ?? "";
    _nomCtrl.text = c.nom ?? "";
    _descCtrl.text = c.desc ?? "";
    _progIdCtrl.text = c.progId?.toString() ?? "";
    _sessionCtrl.text = c.session ?? "";
    _noteNumCtrl.text = c.noteNum?.toString() ?? "";
    _noteAlphaCtrl.text = c.noteAlpha ?? "";
    _categCtrl.text = c.categ?.toString() ?? "";
    _remarqueCtrl.text = c.remarque ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cours = Cours(
      id: widget.cours?.id,
      globId: _globIdCtrl.text.isEmpty ? null : int.tryParse(_globIdCtrl.text),
      code: _codeCtrl.text,
      nom: _nomCtrl.text,
      desc: _descCtrl.text,
      progId: _progIdCtrl.text.isEmpty ? null : int.tryParse(_progIdCtrl.text),
      session: _sessionCtrl.text,
      noteNum:
          _noteNumCtrl.text.isEmpty ? null : int.tryParse(_noteNumCtrl.text),
      noteAlpha: _noteAlphaCtrl.text,
      categ: _categCtrl.text.isEmpty ? null : int.tryParse(_categCtrl.text),
      remarque: _remarqueCtrl.text,
    );

    if (widget.cours == null) {
      await _service.create(cours);
    } else {
      await _service.update(cours);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cours != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier cours" : "Nouveau cours"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Code", _codeCtrl, required: true),
              _field("Nom", _nomCtrl, required: true),
              _field("Description", _descCtrl, maxLines: 3),
              _field("Session", _sessionCtrl),
              _field("Note numérique", _noteNumCtrl,
                  keyboard: TextInputType.number),
              _field("Note alpha", _noteAlphaCtrl),
              _field("Catégorie", _categCtrl,
                  keyboard: TextInputType.number),
              _field("Remarque", _remarqueCtrl, maxLines: 3),
              _field("ID programme", _progIdCtrl,
                  keyboard: TextInputType.number),
              _field("ID global_info", _globIdCtrl,
                  keyboard: TextInputType.number),

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
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboard,
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
