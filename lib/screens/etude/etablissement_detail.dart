// ssc1_app/lib/screens/etudes/etablissement_detail.dart
//
// Écran : Détail d’un établissement (version SSC1)
// ------------------------------------------------
// Affiche TOUS les champs de la table SQL "etablissement".
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/etablissement_model.dart';
import '../../services/etablissement_service.dart';

import 'etablissement_form.dart';

class EtablissementDetail extends StatefulWidget {
  final Etablissement etablissement;

  const EtablissementDetail({super.key, required this.etablissement});

  @override
  State<EtablissementDetail> createState() => _EtablissementDetailState();
}

class _EtablissementDetailState extends State<EtablissementDetail> {
  final _service = EtablissementService();

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EtablissementForm(etablissement: widget.etablissement),
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
        content: const Text("Voulez-vous vraiment supprimer cet établissement ?"),
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

    await _service.delete(widget.etablissement.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final e = widget.etablissement;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Établissement"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Nom", e.nom),
            _section("Adresse", e.adresse),
            _section("Ville", e.ville),
            _section("Province", e.prov),
            _section("Code postal", e.codePostal),
            _section("Pays", e.pays),
            _section("Téléphone", e.telephone),
            _section("Fax", e.fax),
            _section("Courriel", e.courriel),
            _section("Site Web", e.siteUrl),
            _section("Description", e.desc),
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