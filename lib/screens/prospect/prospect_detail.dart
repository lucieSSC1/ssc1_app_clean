// ssc1_app/lib/screens/prospect/prospect_detail.dart
//
// Écran : Détail d’un prospect (version SSC1)
// -------------------------------------------
// Affiche TOUS les champs de la table SQL "prospect".
//
// Champs SQL :
// - nom
// - entreprise
// - telephone
// - courriel
// - site_url
// - adresse
// - ville
// - prov
// - pays
// - commentaire
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/prospect_model.dart';
import '../../services/prospect_service.dart';

import 'prospect_form.dart';

class ProspectDetail extends StatefulWidget {
  final Prospect prospect;

  const ProspectDetail({super.key, required this.prospect});

  @override
  State<ProspectDetail> createState() => _ProspectDetailState();
}

class _ProspectDetailState extends State<ProspectDetail> {
  final _service = ProspectService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProspectForm(prospect: widget.prospect),
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
        content: const Text("Voulez-vous vraiment supprimer ce prospect ?"),
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

    await _service.delete(widget.prospect.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final p = widget.prospect;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Prospect"),
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
            _section("Entreprise", p.entreprise),
            _section("Téléphone", p.telephone),
            _section("Courriel", p.courriel),
            _section("Site web", p.siteUrl),
            _section("Adresse", p.adresse),
            _section("Ville", p.ville),
            _section("Province", p.prov),
            _section("Pays", p.pays),
            _section("Commentaire", p.commentaire),
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