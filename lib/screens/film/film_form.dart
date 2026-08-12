// ssc1_app/lib/screens/film/film_form.dart
//
// Formulaire : Film (module Loisir - SSC1)
// ----------------------------------------
// Permet de créer ou modifier un film.
// Correspond EXACTEMENT à la table SQL "film".
//
// Champs SQL :
// - titre
// - description
// - acteurs
// - realisateur
// - affiche_url
// - notes

import 'package:flutter/material.dart';

import '../../models/film_model.dart';
import '../../services/film_service.dart';

class FilmForm extends StatefulWidget {
  final Film? film;

  const FilmForm({super.key, this.film});

  @override
  State<FilmForm> createState() => _FilmFormState();
}

class _FilmFormState extends State<FilmForm> {
  final _formKey = GlobalKey<FormState>();

  final _titreCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _acteursCtrl = TextEditingController();
  final _realisateurCtrl = TextEditingController();
  final _afficheUrlCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  final _service = FilmService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger les données existantes
  // ------------------------------------------------------------
  void _charger() {
    final f = widget.film;
    if (f == null) return;

    _titreCtrl.text = f.titre ?? "";
    _descriptionCtrl.text = f.description ?? "";
    _acteursCtrl.text = f.acteurs ?? "";
    _realisateurCtrl.text = f.realisateur ?? "";
    _afficheUrlCtrl.text = f.afficheUrl ?? "";
    _notesCtrl.text = f.notes ?? "";
  }

  // ------------------------------------------------------------
  // Sauvegarder
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final film = Film(
      id: widget.film?.id,
      titre: _titreCtrl.text,
      description: _descriptionCtrl.text,
      acteurs: _acteursCtrl.text,
      realisateur: _realisateurCtrl.text,
      afficheUrl: _afficheUrlCtrl.text,
      notes: _notesCtrl.text,
    );

    if (widget.film == null) {
      await _service.create(film);
    } else {
      await _service.update(film);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.film != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier film" : "Nouveau film"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Titre", _titreCtrl, required: true),
              _field("Description", _descriptionCtrl, maxLines: 3),
              _field("Acteurs", _acteursCtrl),
              _field("Réalisateur", _realisateurCtrl),
              _field("URL de l'affiche", _afficheUrlCtrl),
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
