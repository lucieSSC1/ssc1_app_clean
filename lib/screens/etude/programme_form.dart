// ssc1_app/lib/screens/etudes/programme_form.dart
//
// Formulaire : Programme (version SSC1)
// -------------------------------------
// Permet de créer ou modifier un programme d'études.
// Correspond EXACTEMENT à la table SQL "programme".
//
// Champs :
// - nom
// - desc
// - rem
// - cout
// - etablissement_id
// - glob_id
//
// Ce fichier était vide dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/programme_model.dart';
import '../../services/programme_service.dart';

class ProgrammeForm extends StatefulWidget {
  final Programme? programme;

  const ProgrammeForm({super.key, this.programme});

  @override
  State<ProgrammeForm> createState() => _ProgrammeFormState();
}

class _ProgrammeFormState extends State<ProgrammeForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _remCtrl = TextEditingController();
  final _coutCtrl = TextEditingController();
  final _etablissementIdCtrl = TextEditingController();
  final _globIdCtrl = TextEditingController();

  final _service = ProgrammeService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final p = widget.programme;
    if (p == null) return;

    _nomCtrl.text = p.nom ?? "";
    _descCtrl.text = p.desc ?? "";
    _remCtrl.text = p.rem ?? "";
    _coutCtrl.text = p.cout?.toString() ?? "";
    _etablissementIdCtrl.text = p.etablissementId?.toString() ?? "";
    _globIdCtrl.text = p.globId?.toString() ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final programme = Programme(
      id: widget.programme?.id,
      nom: _nomCtrl.text,
      desc: _descCtrl.text,
      rem: _remCtrl.text,
      cout: _coutCtrl.text.isEmpty ? null : double.tryParse(_coutCtrl.text),
      etablissementId: _etablissementIdCtrl.text.isEmpty
          ? null
          : int.tryParse(_etablissementIdCtrl.text),
      globId: _globIdCtrl.text.isEmpty
          ? null
          : int.tryParse(_globIdCtrl.text),
    );

    if (widget.programme == null) {
      await _service.create(programme);
    } else {
      await _service.update(programme);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.programme != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier programme" : "Nouveau programme"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Nom", _nomCtrl, required: true),
              _field("Description", _descCtrl, maxLines: 3),
              _field("Remarques", _remCtrl, maxLines: 3),
              _field("Coût", _coutCtrl, keyboard: TextInputType.number),
              _field("ID établissement", _etablissementIdCtrl,
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
