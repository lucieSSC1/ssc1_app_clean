// ssc1_app/lib/screens/biographie/reference_detail.dart
//
// Écran : Détail d’une référence documentaire (version SSC1)
// ----------------------------------------------------------
// Affiche TOUS les champs de la table SQL "reference".
// Compatible avec tous les types de médias : livre, DVD, audio,
// vidéo, article, document, etc.
//
// Actions :
// - Modifier
// - Supprimer
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/reference_model.dart';
import '../../models/global_info_model.dart';

import '../../services/reference_service.dart';
import '../../services/global_info_service.dart';

import 'reference_form.dart';

class ReferenceDetail extends StatefulWidget {
  final Reference reference;

  const ReferenceDetail({super.key, required this.reference});

  @override
  State<ReferenceDetail> createState() => _ReferenceDetailState();
}

class _ReferenceDetailState extends State<ReferenceDetail> {
  final _service = ReferenceService();
  final _globService = GlobalInfoService();

  GlobalInfo? _info;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger GlobalInfo
  // ------------------------------------------------------------
  Future<void> _charger() async {
    if (widget.reference.globId != null) {
      _info = await _globService.getById(widget.reference.globId!);
    }

    setState(() => _loading = false);
  }

  // ------------------------------------------------------------
  // Format date
  // ------------------------------------------------------------
  String _formatDate(DateTime? d) {
    if (d == null) return "—";
    return "${d.day.toString().padLeft(2, '0')}-"
           "${d.month.toString().padLeft(2, '0')}-"
           "${d.year}";
  }

  // ------------------------------------------------------------
  // Modifier
  // ------------------------------------------------------------
  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReferenceForm(reference: widget.reference),
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
        content: const Text("Voulez-vous vraiment supprimer cette référence ?"),
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

    await _service.delete(widget.reference.id!);

    if (widget.reference.globId != null) {
      await _globService.delete(widget.reference.globId!);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final r = widget.reference;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Référence"),
        actions: [
          IconButton(icon: const Icon(Icons.edit), onPressed: _modifier),
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                children: [
                  _section("Type", r.type),
                  _section("Titre", r.titre),
                  _section("Auteur", r.auteur),
                  _section("Date", _formatDate(r.date)),
                  _section("Domaine", r.domaine),
                  _section("Catégorie (texte)", r.categ),
                  _section("Description", r.desc),
                  _section("Location", r.location),
                  _section("Collection", r.collection),

                  const Divider(height: 40),
                  const Text("Source (articles)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("Source", r.source),
                  _section("Section", r.section),
                  _section("Page", r.page),
                  _section("Texte section", r.txtSection),

                  const Divider(height: 40),
                  const Text("Fichiers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("PDF", r.pdf),
                  _section("Format", r.format),
                  _section("Medium", r.medium),

                  const Divider(height: 40),
                  const Text("Informations bibliographiques", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("ISBN", r.isbn),
                  _section("Éditeur (nom)", r.editeurNom),
                  _section("Éditeur (lieu)", r.editeurLieu),
                  _section("Copyright", r.copyright),
                  _section("Pages", r.pages?.toString()),
                  _section("Prix", r.prix != null ? "${r.prix} \$" : "—"),

                  const Divider(height: 40),
                  const Text("Liens internes SSC1", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("Programme ID", r.programmeId?.toString()),
                  _section("Projet ID", r.projetId?.toString()),

                  const Divider(height: 40),
                  const Text("Statut et notes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("Statut", r.statut),
                  _section("Commentaire", r.commentaire),
                  _section("Info", r.info),

                  const Divider(height: 40),
                  const Text("Chronologie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _section("Début", _formatDate(_info?.debut)),
                  _section("Fin", _formatDate(_info?.fin)),
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
          Text(value == null || value.isEmpty ? "—" : value,
              style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}