// ssc1_app/lib/screens/biographie/global_info_detail.dart
//
// Écran : Détail d’une GlobalInfo
// --------------------------------
// Affiche :
// - type
// - début
// - fin
//
// Actions :
// - Modifier (ouvre global_info_form.dart)
// - Supprimer (via GlobalInfoService)
//
// Ce fichier n’existait pas dans structure 2, mais il est essentiel
// dans SSC1 pour compléter le module GlobalInfo.

import 'package:flutter/material.dart';

import '../../models/global_info_model.dart';
import '../../services/global_info_service.dart';

import 'global_info_form.dart';

class GlobalInfoDetail extends StatefulWidget {
  final GlobalInfo info;

  const GlobalInfoDetail({super.key, required this.info});

  @override
  State<GlobalInfoDetail> createState() => _GlobalInfoDetailState();
}

class _GlobalInfoDetailState extends State<GlobalInfoDetail> {
  final _service = GlobalInfoService();

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
        builder: (_) => GlobalInfoForm(info: widget.info),
      ),
    );

    if (updated == true) {
      Navigator.pop(context, true);
    }
  }

  // ------------------------------------------------------------
  // Supprimer
  // ------------------------------------------------------------
  Future<void> _supprimer() async {
    if (widget.info.id == null) return;

    try {
      await _service.delete(widget.info.id!);

      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GlobalInfo #${widget.info.id ?? ''}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _modifier,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _supprimer,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            _section("Type", widget.info.type),
            _section("Début", _formatDate(widget.info.debut)),
            _section("Fin", _formatDate(widget.info.fin)),
          ],
        ),
      ),
    );
  }

  Widget _section(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}