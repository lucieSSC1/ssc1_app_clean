// ssc1_app/lib/screens/emploi/emploi_detail.dart
//
// Écran : Détail d’un emploi (version SSC1)
// -----------------------------------------
// Affiche TOUS les champs de la table SQL "emploi".
//
// Champs SQL :
// - glob_id
// - fonction
// - employeur_id
// - taches
// - no_contrat
// - taux_horaire
// - commentaire
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/emploi_model.dart';
import '../../services/emploi_service.dart';

import 'emploi_form.dart';

class EmploiDetail extends StatefulWidget {
  final Emploi emploi;

  const EmploiDetail({super.key, required this.emploi});

  @override
  State<EmploiDetail> createState() => _EmploiDetailState();
}

class _EmploiDetailState extends State<EmploiDetail> {
  final _service = EmploiService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmploiForm(emploi: widget.emploi),
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
        content: const Text("Voulez-vous vraiment supprimer cet emploi ?"),
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

    await _service.delete(widget.emploi.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final e = widget.emploi;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emploi"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Fonction", e.fonction),
            _section("Tâches", e.taches),
            _section("No contrat", e.noContrat),
            _section("Taux horaire", e.tauxHoraire?.toString()),
            _section("Commentaire", e.commentaire),
            _section("ID employeur", e.employeurId?.toString()),
            _section("ID global_info", e.globId?.toString()),
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