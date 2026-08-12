// ssc1_app/lib/screens/biographie/acquisition_detail.dart
//
// �cran : D�tail d�une acquisition (version SSC1)
// -----------------------------------------------
// - Affiche les infos principales de l�acquisition
// - Affiche les dates (GlobalInfo)
// - Affiche le vendeur (si pr�sent)
// - Permet : modifier, supprimer
//
// Ce fichier n�existait pas dans structure 2 : il compl�te le module
// Acquisition dans la structure 4.

import 'package:flutter/material.dart';

// Models
import '../../models/acquisition_model.dart';
import '../../models/global_info_model.dart';

// Services
import '../../services/acquisition_service.dart';
import '../../services/global_info_service.dart';

import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';

// Formulaire dans le même dossier
import 'acquisition_form.dart';

class AcquisitionDetail extends StatefulWidget {
  final Acquisition acquisition;

  const AcquisitionDetail({super.key, required this.acquisition});

  @override
  State<AcquisitionDetail> createState() => _AcquisitionDetailState();
}

class _AcquisitionDetailState extends State<AcquisitionDetail> {
  final _acqService = AcquisitionService();
  final _globService = GlobalInfoService();
  final _vendService = VendeurService();

  GlobalInfo? _info;
  Vendeur? _vendeur;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger GlobalInfo + Vendeur
  // ------------------------------------------------------------
  Future<void> _charger() async {
    final a = widget.acquisition;

    GlobalInfo? info;
    Vendeur? vendeur;

    if (a.globId != null) {
      info = await _globService.getById(a.globId!);
    }

    if (a.vendeurId != null) {
      vendeur = await _vendService.getById(a.vendeurId!);
    }

    setState(() {
      _info = info;
      _vendeur = vendeur;
      _loading = false;
    });
  }

  // ------------------------------------------------------------
  // Format date
  // ------------------------------------------------------------
  String _formatDate(DateTime? d) {
    if (d == null) return "�";
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
        builder: (_) => AcquisitionForm(acquisition: widget.acquisition),
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
        content: const Text(
          "Voulez-vous vraiment supprimer cette acquisition ?",
        ),
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

    await _acqService.delete(widget.acquisition.id!);

    if (widget.acquisition.globId != null) {
      await _globService.delete(widget.acquisition.globId!);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.acquisition.nom),
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
                  _section("Nom", widget.acquisition.nom),
                  _section(
                    "Description",
                    widget.acquisition.description ?? "�",
                  ),
                  _section(
                    "Prix",
                    widget.acquisition.prix != null
                        ? "${widget.acquisition.prix} \$"
                        : "�",
                  ),
                  _section("D�but", _formatDate(_info?.debut)),
                  _section("Fin", _formatDate(_info?.fin)),
                  _section("Vendeur", _vendeur?.nom ?? "�"),
                ],
              ),
            ),
    );
  }

  Widget _section(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
