// ssc1_app/lib/screens/prospect/prospect_form.dart
//
// Formulaire : Prospect (version SSC1)
// ------------------------------------
// Permet de créer ou modifier un prospect.
// Correspond EXACTEMENT à la table SQL "prospect".
//
// Champs SQL :
// - nom
// - entreprise
// - telephone
// - courriel
// - site_url
// - adresse
// - ville
// - prov
// - pays
// - commentaire
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/prospect_model.dart';
import '../../services/prospect_service.dart';

class ProspectForm extends StatefulWidget {
  final Prospect? prospect;

  const ProspectForm({super.key, this.prospect});

  @override
  State<ProspectForm> createState() => _ProspectFormState();
}

class _ProspectFormState extends State<ProspectForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _entrepriseCtrl = TextEditingController();
  final _telephoneCtrl = TextEditingController();
  final _courrielCtrl = TextEditingController();
  final _siteUrlCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _provCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();

  final _service = ProspectService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final p = widget.prospect;
    if (p == null) return;

    _nomCtrl.text = p.nom ?? "";
    _entrepriseCtrl.text = p.entreprise ?? "";
    _telephoneCtrl.text = p.telephone ?? "";
    _courrielCtrl.text = p.courriel ?? "";
    _siteUrlCtrl.text = p.siteUrl ?? "";
    _adresseCtrl.text = p.adresse ?? "";
    _villeCtrl.text = p.ville ?? "";
    _provCtrl.text = p.prov ?? "";
    _paysCtrl.text = p.pays ?? "";
    _commentaireCtrl.text = p.commentaire ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final prospect = Prospect(
      id: widget.prospect?.id,
      nom: _nomCtrl.text,
      entreprise: _entrepriseCtrl.text,
      telephone: _telephoneCtrl.text,
      courriel: _courrielCtrl.text,
      siteUrl: _siteUrlCtrl.text,
      adresse: _adresseCtrl.text,
      ville: _villeCtrl.text,
      prov: _provCtrl.text,
      pays: _paysCtrl.text,
      commentaire: _commentaireCtrl.text,
    );

    if (widget.prospect == null) {
      await _service.create(prospect);
    } else {
      await _service.update(prospect);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.prospect != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier prospect" : "Nouveau prospect"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Nom", _nomCtrl),
              _field("Entreprise", _entrepriseCtrl),
              _field("Téléphone", _telephoneCtrl),
              _field("Courriel", _courrielCtrl),
              _field("Site web", _siteUrlCtrl),
              _field("Adresse", _adresseCtrl),
              _field("Ville", _villeCtrl),
              _field("Province", _provCtrl),
              _field("Pays", _paysCtrl),
              _field("Commentaire", _commentaireCtrl, maxLines: 3),

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
