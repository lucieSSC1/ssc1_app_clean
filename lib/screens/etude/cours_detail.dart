// ssc1_app/lib/screens/etudes/cours_detail.dart
//
// Écran : Détail d’un cours (version SSC1)
// ----------------------------------------
// Affiche TOUS les champs de la table SQL "cours".
//
// Champs SQL :
// - glob_id
// - code
// - nom
// - desc
// - prog_id
// - session
// - note_num
// - note_alpha
// - categ
// - remarque
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/cours_model.dart';
import '../../services/cours_service.dart';

import 'cours_form.dart';

class CoursDetail extends StatefulWidget {
  final Cours cours;

  const CoursDetail({super.key, required this.cours});

  @override
  State<CoursDetail> createState() => _CoursDetailState();
}

class _CoursDetailState extends State<CoursDetail> {
  final _service = CoursService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoursForm(cours: widget.cours),
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
        content: const Text("Voulez-vous vraiment supprimer ce cours ?"),
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

    await _service.delete(widget.cours.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final c = widget.cours;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cours"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Code", c.code),
            _section("Nom", c.nom),
            _section("Description", c.desc),
            _section("Session", c.session),
            _section("Note numérique", c.noteNum?.toString()),
            _section("Note alpha", c.noteAlpha),
            _section("Catégorie", c.categ?.toString()),
            _section("Remarque", c.remarque),
            _section("ID programme", c.progId?.toString()),
            _section("ID global_info", c.globId?.toString()),
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