// ssc1_app/lib/screens/ecrit/ecrit_detail.dart
//
// Écran : Détail d’un écrit (module Loisir - SSC1)
// ------------------------------------------------
// Affiche TOUS les champs de la table SQL "ecrit".
//
// Champs SQL :
// - titre
// - type
// - auteur
// - texte_url
// - notes
//
// Actions :
// - Modifier
// - Supprimer

import 'package:flutter/material.dart';

import '../../models/ecrit_model.dart';
import '../../services/ecrit_service.dart';

import 'ecrit_form.dart';

class EcritDetail extends StatefulWidget {
  final Ecrit ecrit;

  const EcritDetail({super.key, required this.ecrit});

  @override
  State<EcritDetail> createState() => _EcritDetailState();
}

class _EcritDetailState extends State<EcritDetail> {
  final _service = EcritService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EcritForm(ecrit: widget.ecrit),
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
        content: const Text("Voulez-vous vraiment supprimer cet écrit ?"),
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

    await _service.delete(widget.ecrit.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final e = widget.ecrit;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Écrit"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Titre", e.titre),
            _section("Type", e.type),
            _section("Auteur", e.auteur),
            _section("Texte (URL)", e.texteUrl),
            _section("Notes", e.notes),
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