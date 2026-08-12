// ssc1_app/lib/screens/emploi/emploi_form.dart
//
// Formulaire : Emploi (version SSC1)
// ----------------------------------
// Permet de créer ou modifier un emploi.
// Correspond EXACTEMENT à la table SQL "emploi".
//
// Champs :
// - glob_id
// - fonction
// - employeur_id
// - taches
// - no_contrat
// - taux_horaire
// - commentaire
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/emploi_model.dart';
import '../../services/emploi_service.dart';

class EmploiForm extends StatefulWidget {
  final Emploi? emploi;

  const EmploiForm({super.key, this.emploi});

  @override
  State<EmploiForm> createState() => _EmploiFormState();
}

class _EmploiFormState extends State<EmploiForm> {
  final _formKey = GlobalKey<FormState>();

  final _globIdCtrl = TextEditingController();
  final _fonctionCtrl = TextEditingController();
  final _employeurIdCtrl = TextEditingController();
  final _tachesCtrl = TextEditingController();
  final _noContratCtrl = TextEditingController();
  final _tauxHoraireCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();

  final _service = EmploiService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final e = widget.emploi;
    if (e == null) return;

    _globIdCtrl.text = e.globId?.toString() ?? "";
    _fonctionCtrl.text = e.fonction ?? "";
    _employeurIdCtrl.text = e.employeurId?.toString() ?? "";
    _tachesCtrl.text = e.taches ?? "";
    _noContratCtrl.text = e.noContrat ?? "";
    _tauxHoraireCtrl.text = e.tauxHoraire?.toString() ?? "";
    _commentaireCtrl.text = e.commentaire ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final emploi = Emploi(
      id: widget.emploi?.id,
      globId: _globIdCtrl.text.isEmpty ? null : int.tryParse(_globIdCtrl.text),
      fonction: _fonctionCtrl.text,
      employeurId: _employeurIdCtrl.text.isEmpty
          ? null
          : int.tryParse(_employeurIdCtrl.text),
      taches: _tachesCtrl.text,
      noContrat: _noContratCtrl.text,
      tauxHoraire: _tauxHoraireCtrl.text.isEmpty
          ? null
          : double.tryParse(_tauxHoraireCtrl.text),
      commentaire: _commentaireCtrl.text,
    );

    if (widget.emploi == null) {
      await _service.create(emploi);
    } else {
      await _service.update(emploi);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.emploi != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier emploi" : "Nouvel emploi"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Fonction", _fonctionCtrl, required: true),
              _field("Tâches", _tachesCtrl, maxLines: 3),
              _field("No contrat", _noContratCtrl),
              _field("Taux horaire", _tauxHoraireCtrl,
                  keyboard: TextInputType.number),
              _field("Commentaire", _commentaireCtrl, maxLines: 3),
              _field("ID employeur", _employeurIdCtrl,
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
