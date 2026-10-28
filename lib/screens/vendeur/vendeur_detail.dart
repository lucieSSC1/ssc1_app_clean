// lib/screens/vendeur/vendeur_detail.dart
//
// FICHE : Vendeur (version SSC1)
// ------------------------------
// - Affiche tous les champs SQL
// - PAS de bouton +Ajouter
// - Bouton Modifier
// - Bouton Supprimer
// - Largeur 420 px (comme Acquisition)
// ------------------------------

import 'package:flutter/material.dart';

import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';
import 'vendeur_form.dart';

class VendeurDetail extends StatefulWidget {
  final Vendeur vendeur;

  const VendeurDetail({super.key, required this.vendeur});

  @override
  State<VendeurDetail> createState() => _VendeurDetailState();
}

class _VendeurDetailState extends State<VendeurDetail> {
  final _service = VendeurService();

  late Vendeur _v;

  @override
  void initState() {
    super.initState();
    _v = widget.vendeur;
  }

  Future<void> _modifier() async {
    final result = await showDialog<Vendeur?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: SizedBox(width: 420, child: VendeurForm(vendeur: _v)),
      ),
    );

    if (result != null) {
      setState(() => _v = result);
    }
  }

  Future<void> _supprimer() async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer vendeur"),
        content: Text("Supprimer ${_v.nom} ?"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.delete(_v.id!);
      if (!mounted) return;
      Navigator.pop(context, true); // retourne à la liste
    }
  }

  Widget _ligne(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche vendeur"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          // ✔ PAS de bouton +Ajouter
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Modifier",
            onPressed: _modifier,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Supprimer",
            onPressed: _supprimer,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _ligne("Nom", _v.nom),
                _ligne("Adresse", _v.adresse ?? "-"),
                _ligne("Ville", _v.ville ?? "-"),
                _ligne("Province", _v.prov ?? "-"),
                _ligne("Code postal", _v.codePostal ?? "-"),
                _ligne("Pays", _v.pays ?? "-"),
                _ligne("Téléphone", _v.telephone ?? "-"),
                _ligne("Fax", _v.fax ?? "-"),
                _ligne("Courriel", _v.courriel ?? "-"),
                _ligne("Site Web", _v.siteUrl ?? "-"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
