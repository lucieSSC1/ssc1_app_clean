// ssc1_app/lib/screens/etudes/etablissement_form.dart
//
// Formulaire : Établissement (version SSC1)
// -----------------------------------------
// Permet de créer ou modifier un établissement.
// Correspond EXACTEMENT à la table SQL "etablissement".
//
// Champs :
// - nom
// - adresse
// - ville
// - prov
// - code_postal
// - pays
// - telephone
// - fax
// - courriel
// - site_url
// - desc
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/etablissement_model.dart';
import '../../services/etablissement_service.dart';

class EtablissementForm extends StatefulWidget {
  final Etablissement? etablissement;

  const EtablissementForm({super.key, this.etablissement});

  @override
  State<EtablissementForm> createState() => _EtablissementFormState();
}

class _EtablissementFormState extends State<EtablissementForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _provCtrl = TextEditingController();
  final _codePostalCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _faxCtrl = TextEditingController();
  final _courrielCtrl = TextEditingController();
  final _siteUrlCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  final _service = EtablissementService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final e = widget.etablissement;
    if (e == null) return;

    _nomCtrl.text = e.nom ?? "";
    _adresseCtrl.text = e.adresse ?? "";
    _villeCtrl.text = e.ville ?? "";
    _provCtrl.text = e.prov ?? "";
    _codePostalCtrl.text = e.codePostal ?? "";
    _paysCtrl.text = e.pays ?? "";
    _telephoneCtrl.text = e.telephone ?? "";
    _faxCtrl.text = e.fax ?? "";
    _courrielCtrl.text = e.courriel ?? "";
    _siteUrlCtrl.text = e.siteUrl ?? "";
    _descCtrl.text = e.desc ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final etab = Etablissement(
      id: widget.etablissement?.id,
      nom: _nomCtrl.text,
      adresse: _adresseCtrl.text,
      ville: _villeCtrl.text,
      prov: _provCtrl.text,
      codePostal: _codePostalCtrl.text,
      pays: _paysCtrl.text,
      telephone: _telephoneCtrl.text,
      fax: _faxCtrl.text,
      courriel: _courrielCtrl.text,
      siteUrl: _siteUrlCtrl.text,
      desc: _descCtrl.text,
    );

    if (widget.etablissement == null) {
      await _service.create(etab);
    } else {
      await _service.update(etab);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.etablissement != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier établissement" : "Nouvel établissement"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Nom", _nomCtrl, required: true),
              _field("Adresse", _adresseCtrl),
              _field("Ville", _villeCtrl),
              _field("Province", _provCtrl),
              _field("Code postal", _codePostalCtrl),
              _field("Pays", _paysCtrl),
              _field("Téléphone", _telephoneCtrl),
              _field("Fax", _faxCtrl),
              _field("Courriel", _courrielCtrl),
              _field("Site Web", _siteUrlCtrl),
              _field("Description", _descCtrl, maxLines: 3),

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
