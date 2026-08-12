// ssc1_app/lib/screens/demarche/demarche_form.dart
//
// Formulaire : Démarche (version SSC1, sans accents dans les champs)
// -----------------------------------------------------------------
// Permet de créer ou modifier une démarche.
// Correspond EXACTEMENT à la table SQL "demarche".
//
// Champs :
// - date
// - domaine
// - service
// - service_details
// - mot_cle1
// - mot_cle2
// - mot_cle3
// - prosp_id
// - pending
// - entente
// - interactions
// - lettre_url
// - cv_url
// - preparation_url
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/demarche_model.dart';
import '../../services/demarche_service.dart';

class DemarcheForm extends StatefulWidget {
  final Demarche? demarche;

  const DemarcheForm({super.key, this.demarche});

  @override
  State<DemarcheForm> createState() => _DemarcheFormState();
}

class _DemarcheFormState extends State<DemarcheForm> {
  final _formKey = GlobalKey<FormState>();

  final _dateCtrl = TextEditingController();
  final _domaineCtrl = TextEditingController();
  final _serviceCtrl = TextEditingController();
  final _serviceDetailsCtrl = TextEditingController();
  final _motCle1Ctrl = TextEditingController();
  final _motCle2Ctrl = TextEditingController();
  final _motCle3Ctrl = TextEditingController();
  final _prospIdCtrl = TextEditingController();
  bool _pending = false;
  bool _entente = false;
  final _interactionsCtrl = TextEditingController();
  final _lettreUrlCtrl = TextEditingController();
  final _cvUrlCtrl = TextEditingController();
  final _preparationUrlCtrl = TextEditingController();

  final _service = DemarcheService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final d = widget.demarche;
    if (d == null) return;

    _dateCtrl.text = d.date?.toIso8601String().split("T").first ?? "";
    _domaineCtrl.text = d.domaine ?? "";
    _serviceCtrl.text = d.service ?? "";
    _serviceDetailsCtrl.text = d.serviceDetails ?? "";
    _motCle1Ctrl.text = d.motCle1 ?? "";
    _motCle2Ctrl.text = d.motCle2 ?? "";
    _motCle3Ctrl.text = d.motCle3 ?? "";
    _prospIdCtrl.text = d.prospId?.toString() ?? "";
    _pending = d.pending ?? false;
    _entente = d.entente ?? false;
    _interactionsCtrl.text = d.interactions ?? "";
    _lettreUrlCtrl.text = d.lettreUrl ?? "";
    _cvUrlCtrl.text = d.cvUrl ?? "";
    _preparationUrlCtrl.text = d.preparationUrl ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final demarche = Demarche(
      id: widget.demarche?.id,
      date: _dateCtrl.text.isEmpty ? null : DateTime.tryParse(_dateCtrl.text),
      domaine: _domaineCtrl.text,
      service: _serviceCtrl.text,
      serviceDetails: _serviceDetailsCtrl.text,
      motCle1: _motCle1Ctrl.text,
      motCle2: _motCle2Ctrl.text,
      motCle3: _motCle3Ctrl.text,
      prospId: _prospIdCtrl.text.isEmpty ? null : int.tryParse(_prospIdCtrl.text),
      pending: _pending,
      entente: _entente,
      interactions: _interactionsCtrl.text,
      lettreUrl: _lettreUrlCtrl.text,
      cvUrl: _cvUrlCtrl.text,
      preparationUrl: _preparationUrlCtrl.text,
    );

    if (widget.demarche == null) {
      await _service.create(demarche);
    } else {
      await _service.update(demarche);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.demarche != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier démarche" : "Nouvelle démarche"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Date (AAAA-MM-JJ)", _dateCtrl, keyboard: TextInputType.datetime),
              _field("Domaine", _domaineCtrl),
              _field("Service", _serviceCtrl),
              _field("Détails du service", _serviceDetailsCtrl, maxLines: 2),
              _field("Mot clé 1", _motCle1Ctrl),
              _field("Mot clé 2", _motCle2Ctrl),
              _field("Mot clé 3", _motCle3Ctrl),
              _field("ID prospect", _prospIdCtrl, keyboard: TextInputType.number),

              SwitchListTile(
                title: const Text("Pending"),
                value: _pending,
                onChanged: (v) => setState(() => _pending = v),
              ),

              SwitchListTile(
                title: const Text("Entente"),
                value: _entente,
                onChanged: (v) => setState(() => _entente = v),
              ),

              _field("Interactions", _interactionsCtrl, maxLines: 3),
              _field("Lettre URL", _lettreUrlCtrl),
              _field("CV URL", _cvUrlCtrl),
              _field("Préparation URL", _preparationUrlCtrl),

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
