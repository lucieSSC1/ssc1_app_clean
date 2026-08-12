// ssc1_app/lib/screens/film/film_detail.dart
//
// Écran : Détail d’un film (module Loisir - SSC1)
// -----------------------------------------------
// Affiche TOUS les champs de la table SQL "film".
//
// Champs SQL :
// - titre
// - description
// - acteurs
// - realisateur
// - affiche_url
// - notes
//
// Actions :
// - Modifier
// - Supprimer

import 'package:flutter/material.dart';

import '../../models/film_model.dart';
import '../../services/film_service.dart';

import 'film_form.dart';

class FilmDetail extends StatefulWidget {
  final Film film;

  const FilmDetail({super.key, required this.film});

  @override
  State<FilmDetail> createState() => _FilmDetailState();
}

class _FilmDetailState extends State<FilmDetail> {
  final _service = FilmService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilmForm(film: widget.film),
      ),
    );

    if (updated == true) {
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  // ------------------------------------------------------------
  // Supprimer
  // ------------------------------------------------------------
  Future<void> _supprimer() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: const Text("Voulez-vous vraiment supprimer ce film ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    await _service.delete(widget.film.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final f = widget.film;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Film"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Titre", f.titre),
            _section("Description", f.description),
            _section("Acteurs", f.acteurs),
            _section("Réalisateur", f.realisateur),
            _section("Affiche (URL)", f.afficheUrl),
            _section("Notes", f.notes),
          ],
        ),
      ),
    );
  }

  Widget _section(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            value == null || value.isEmpty ? "—" : value,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}