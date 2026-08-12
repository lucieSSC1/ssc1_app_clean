// ssc1_app/lib/screens/etudes/programme_detail.dart
//
// Écran : Détail d’un programme (version SSC1)
// --------------------------------------------
// Affiche TOUS les champs de la table SQL "programme".
//
// Champs SQL :
// - nom
// - desc
// - rem
// - cout
// - etablissement_id
// - glob_id
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier était vide dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/programme_model.dart';
import '../../services/programme_service.dart';

import 'programme_form.dart';

class ProgrammeDetail extends StatefulWidget {
  final Programme programme;

  const ProgrammeDetail({super.key, required this.programme});

  @override
  State<ProgrammeDetail> createState() => _ProgrammeDetailState();
}

class _ProgrammeDetailState extends State<ProgrammeDetail> {
  final _service = ProgrammeService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProgrammeForm(programme: widget.programme),
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
        content: const Text("Voulez-vous vraiment supprimer ce programme ?"),
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

    await _service.delete(widget.programme.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final p = widget.programme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Programme"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Nom", p.nom),
            _section("Description", p.desc),
            _section("Remarques", p.rem),
            _section("Coût", p.cout?.toString()),
            _section("ID établissement", p.etablissementId?.toString()),
            _section("ID global_info", p.globId?.toString()),
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