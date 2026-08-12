// ssc1_app/lib/screens/chanson/chanson_detail.dart
//
// Écran : Détail d’une chanson (module Loisir - SSC1)
// ---------------------------------------------------
// Affiche TOUS les champs de la table SQL "chanson".
//
// Champs SQL :
// - titre
// - auteur
// - compositeur
// - interprete
// - paroles_url
// - notes
//
// Actions :
// - Modifier
// - Supprimer

import 'package:flutter/material.dart';

import '../../models/chanson_model.dart';
import '../../services/chanson_service.dart';

import 'chanson_form.dart';

class ChansonDetail extends StatefulWidget {
  final Chanson chanson;

  const ChansonDetail({super.key, required this.chanson});

  @override
  State<ChansonDetail> createState() => _ChansonDetailState();
}

class _ChansonDetailState extends State<ChansonDetail> {
  final _service = ChansonService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChansonForm(chanson: widget.chanson),
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
        content: const Text("Voulez-vous vraiment supprimer cette chanson ?"),
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

    await _service.delete(widget.chanson.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final c = widget.chanson;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chanson"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Titre", c.titre),
            _section("Auteur", c.auteur),
            _section("Compositeur", c.compositeur),
            _section("Interprète", c.interprete),
            _section("Paroles (URL)", c.parolesUrl),
            _section("Notes", c.notes),
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