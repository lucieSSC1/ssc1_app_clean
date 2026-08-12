// ssc1_app/lib/screens/recette/recette_detail.dart
//
// Écran : Détail d’une recette (module Loisir - SSC1)
// ---------------------------------------------------
// Affiche TOUS les champs de la table SQL "recette".
//
// Champs SQL :
// - nom
// - categorie
// - source
// - recette_url
// - notes
//
// Actions :
// - Modifier
// - Supprimer

import 'package:flutter/material.dart';

import '../../models/recette_model.dart';
import '../../services/recette_service.dart';

import 'recette_form.dart';

class RecetteDetail extends StatefulWidget {
  final Recette recette;

  const RecetteDetail({super.key, required this.recette});

  @override
  State<RecetteDetail> createState() => _RecetteDetailState();
}

class _RecetteDetailState extends State<RecetteDetail> {
  final _service = RecetteService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecetteForm(recette: widget.recette),
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
        content: const Text("Voulez-vous vraiment supprimer cette recette ?"),
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

    await _service.delete(widget.recette.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final r = widget.recette;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recette"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Nom", r.nom),
            _section("Catégorie", r.categorie),
            _section("Source", r.source),
            _section("Recette (URL)", r.recetteUrl),
            _section("Notes", r.notes),
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