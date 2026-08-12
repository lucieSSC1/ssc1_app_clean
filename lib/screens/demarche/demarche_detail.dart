// ssc1_app/lib/screens/demarche/demarche_detail.dart
//
// Écran : Détail d’une démarche (version SSC1, sans accents)
// ----------------------------------------------------------
// Affiche TOUS les champs de la table SQL "demarche".
//
// Champs SQL :
// - date
// - domaine
// - service
// - service_details
// - mot_cle1
// - mot_cle2
// - mot_cle3
// - prosp_id
// - pending
// - entente
// - interactions
// - lettre_url
// - cv_url
// - preparation_url
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/demarche_model.dart';
import '../../services/demarche_service.dart';

import 'demarche_form.dart';

class DemarcheDetail extends StatefulWidget {
  final Demarche demarche;

  const DemarcheDetail({super.key, required this.demarche});

  @override
  State<DemarcheDetail> createState() => _DemarcheDetailState();
}

class _DemarcheDetailState extends State<DemarcheDetail> {
  final _service = DemarcheService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DemarcheForm(demarche: widget.demarche),
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
        content: const Text("Voulez-vous vraiment supprimer cette démarche ?"),
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

    await _service.delete(widget.demarche.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final d = widget.demarche;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Démarche"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Date", d.date?.toIso8601String().split("T").first),
            _section("Domaine", d.domaine),
            _section("Service", d.service),
            _section("Détails du service", d.serviceDetails),
            _section("Mot clé 1", d.motCle1),
            _section("Mot clé 2", d.motCle2),
            _section("Mot clé 3", d.motCle3),
            _section("ID prospect", d.prospId?.toString()),
            _section("Pending", d.pending == true ? "Oui" : "Non"),
            _section("Entente", d.entente == true ? "Oui" : "Non"),
            _section("Interactions", d.interactions),
            _section("Lettre URL", d.lettreUrl),
            _section("CV URL", d.cvUrl),
            _section("Préparation URL", d.preparationUrl),
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