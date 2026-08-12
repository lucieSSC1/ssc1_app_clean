// ssc1_app/lib/screens/recette/recette_form.dart
//
// Formulaire : Recette (module Loisir - SSC1)
// -------------------------------------------
// Permet de créer ou modifier une recette.
// Correspond EXACTEMENT à la table SQL "recette".
//
// Champs SQL :
// - nom
// - categorie (ENUM)
// - source
// - recette_url
// - notes

import 'package:flutter/material.dart';

import '../../models/recette_model.dart';
import '../../services/recette_service.dart';

class RecetteForm extends StatefulWidget {
  final Recette? recette;

  const RecetteForm({super.key, this.recette});

  @override
  State<RecetteForm> createState() => _RecetteFormState();
}

class _RecetteFormState extends State<RecetteForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _recetteUrlCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String? _categorie;

  final _service = RecetteService();

  // ENUM catégories
  final List<String> _categories = [
    "soupe",
    "entrée",
    "plat principal",
    "dessert",
    "collation",
    "boisson",
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
    final r = widget.recette;
    if (r == null) return;

    _nomCtrl.text = r.nom ?? "";
    _categorie = r.categorie;
    _sourceCtrl.text = r.source ?? "";
    _recetteUrlCtrl.text = r.recetteUrl ?? "";
    _notesCtrl.text = r.notes ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final recette = Recette(
      id: widget.recette?.id,
      nom: _nomCtrl.text,
      categorie: _categorie,
      source: _sourceCtrl.text,
      recetteUrl: _recetteUrlCtrl.text,
      notes: _notesCtrl.text,
    );

    if (widget.recette == null) {
      await _service.create(recette);
    } else {
      await _service.update(recette);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.recette != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier recette" : "Nouvelle recette"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Nom", _nomCtrl, required: true),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categorie,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categorie = v),
                decoration: const InputDecoration(
                  labelText: "Catégorie",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null ? "Veuillez choisir une catégorie" : null,
              ),

              const SizedBox(height: 16),
              _field("Source", _sourceCtrl),

              _field("URL de la recette (Word)", _recetteUrlCtrl),

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