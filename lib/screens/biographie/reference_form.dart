// ssc1_app/lib/screens/biographie/reference_form.dart
//
// Formulaire : Reference (version SSC1)
// -------------------------------------
// Permet de créer ou modifier une référence documentaire.
// Basé STRICTEMENT sur la table SQL "reference".
//
// Champs principaux affichés :
// - type
// - titre
// - auteur
// - date
// - domaine
// - desc
// - location
// - collection
// - pdf
// - format
// - medium
// - ISBN
// - editeur_nom
// - editeur_lieu
// - pages
// - prix
// - statut
// - commentaire
//
// Les autres champs sont accessibles dans une section "Avancé".
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/reference_model.dart';
import '../../models/global_info_model.dart';

import '../../services/reference_service.dart';
import '../../services/global_info_service.dart';

class ReferenceForm extends StatefulWidget {
  final Reference? reference;

  const ReferenceForm({super.key, this.reference});

  @override
  State<ReferenceForm> createState() => _ReferenceFormState();
}

class _ReferenceFormState extends State<ReferenceForm> {
  final _formKey = GlobalKey<FormState>();

  // Champs principaux
  final _typeCtrl = TextEditingController();
  final _titreCtrl = TextEditingController();
  final _auteurCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _domaineCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _collectionCtrl = TextEditingController();
  final _pdfCtrl = TextEditingController();
  final _formatCtrl = TextEditingController();
  final _mediumCtrl = TextEditingController();
  final _isbnCtrl = TextEditingController();
  final _editeurNomCtrl = TextEditingController();
  final _editeurLieuCtrl = TextEditingController();
  final _pagesCtrl = TextEditingController();
  final _prixCtrl = TextEditingController();
  final _statutCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();

  // Champs avancés
  final _categorieIdCtrl = TextEditingController();
  final _categCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _sectionCtrl = TextEditingController();
  final _pageCtrl = TextEditingController();
  final _txtSectionCtrl = TextEditingController();
  final _copyrightCtrl = TextEditingController();
  final _programmeIdCtrl = TextEditingController();
  final _projetIdCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();

  DateTime? _date;

  final _service = ReferenceService();
  final _globService = GlobalInfoService();

  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final r = widget.reference;
    if (r == null) return;

    _typeCtrl.text = r.type ?? "";
    _titreCtrl.text = r.titre ?? "";
    _auteurCtrl.text = r.auteur ?? "";
    _date = r.date;
    _dateCtrl.text = r.date?.toIso8601String().split("T").first ?? "";
    _domaineCtrl.text = r.domaine ?? "";
    _descCtrl.text = r.desc ?? "";
    _locationCtrl.text = r.location ?? "";
    _collectionCtrl.text = r.collection ?? "";
    _pdfCtrl.text = r.pdf ?? "";
    _formatCtrl.text = r.format ?? "";
    _mediumCtrl.text = r.medium ?? "";
    _isbnCtrl.text = r.isbn ?? "";
    _editeurNomCtrl.text = r.editeurNom ?? "";
    _editeurLieuCtrl.text = r.editeurLieu ?? "";
    _pagesCtrl.text = r.pages?.toString() ?? "";
    _prixCtrl.text = r.prix?.toString() ?? "";
    _statutCtrl.text = r.statut ?? "";
    _commentaireCtrl.text = r.commentaire ?? "";

    // Champs avancés
    _categorieIdCtrl.text = r.categorieId?.toString() ?? "";
    _categCtrl.text = r.categ ?? "";
    _sourceCtrl.text = r.source ?? "";
    _sectionCtrl.text = r.section ?? "";
    _pageCtrl.text = r.page ?? "";
    _txtSectionCtrl.text = r.txtSection ?? "";
    _copyrightCtrl.text = r.copyright ?? "";
    _programmeIdCtrl.text = r.programmeId?.toString() ?? "";
    _projetIdCtrl.text = r.projetId?.toString() ?? "";
    _infoCtrl.text = r.info ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ref = Reference(
      id: widget.reference?.id,
      globId: widget.reference?.globId,
      type: _typeCtrl.text,
      categorieId: int.tryParse(_categorieIdCtrl.text),
      titre: _titreCtrl.text,
      auteur: _auteurCtrl.text,
      date: _date,
      domaine: _domaineCtrl.text,
      categ: _categCtrl.text,
      desc: _descCtrl.text,
      location: _locationCtrl.text,
      collection: _collectionCtrl.text,
      source: _sourceCtrl.text,
      section: _sectionCtrl.text,
      page: _pageCtrl.text,
      txtSection: _txtSectionCtrl.text,
      pdf: _pdfCtrl.text,
      format: _formatCtrl.text,
      medium: _mediumCtrl.text,
      isbn: _isbnCtrl.text,
      editeurNom: _editeurNomCtrl.text,
      editeurLieu: _editeurLieuCtrl.text,
      copyright: _copyrightCtrl.text,
      pages: int.tryParse(_pagesCtrl.text),
      prix: double.tryParse(_prixCtrl.text),
      programmeId: int.tryParse(_programmeIdCtrl.text),
      projetId: int.tryParse(_projetIdCtrl.text),
      statut: _statutCtrl.text,
      commentaire: _commentaireCtrl.text,
      info: _infoCtrl.text,
    );

    if (widget.reference == null) {
      await _service.create(ref);
    } else {
      await _service.update(ref);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.reference != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier référence" : "Nouvelle référence"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Type", _typeCtrl),
              _field("Titre", _titreCtrl),
              _field("Auteur", _auteurCtrl),

              _dateField(),

              _field("Domaine", _domaineCtrl),
              _field("Description", _descCtrl, maxLines: 3),
              _field("Location", _locationCtrl),
              _field("Collection", _collectionCtrl),

              _field("PDF", _pdfCtrl),
              _field("Format", _formatCtrl),
              _field("Medium", _mediumCtrl),

              _field("ISBN", _isbnCtrl),
              _field("Éditeur (nom)", _editeurNomCtrl),
              _field("Éditeur (lieu)", _editeurLieuCtrl),

              _field("Pages", _pagesCtrl),
              _field("Prix", _prixCtrl),

              _field("Statut", _statutCtrl),
              _field("Commentaire", _commentaireCtrl, maxLines: 3),

              const SizedBox(height: 20),

              // ------------------------------------------------------------
              // Section avancée
              // ------------------------------------------------------------
              TextButton(
                onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
                child: Text(_showAdvanced ? "Masquer avancé" : "Afficher avancé"),
              ),

              if (_showAdvanced) ...[
                _field("Catégorie ID", _categorieIdCtrl),
                _field("Categ", _categCtrl),
                _field("Source", _sourceCtrl),
                _field("Section", _sectionCtrl),
                _field("Page", _pageCtrl),
                _field("Texte section", _txtSectionCtrl, maxLines: 3),
                _field("Copyright", _copyrightCtrl),
                _field("Programme ID", _programmeIdCtrl),
                _field("Projet ID", _projetIdCtrl),
                _field("Info", _infoCtrl, maxLines: 3),
              ],

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

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final d = await showDatePicker(
            context: context,
            initialDate: _date ?? DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime(2100),
          );
          if (d != null) {
            setState(() {
              _date = d;
              _dateCtrl.text = d.toIso8601String().split("T").first;
            });
          }
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date",
            border: OutlineInputBorder(),
          ),
          child: Text(_dateCtrl.text.isEmpty ? "Choisir" : _dateCtrl.text),
        ),
      ),
    );
  }
}
