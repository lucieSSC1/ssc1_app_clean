import 'package:flutter/material.dart';

import '../../models/residence_model.dart';
import '../../models/global_info_model.dart';

import '../../services/residence_service.dart';
import '../../services/global_info_service.dart';

import 'residence_form.dart';

class ResidenceDetail extends StatefulWidget {
  final Residence residence;

  const ResidenceDetail({super.key, required this.residence});

  @override
  State<ResidenceDetail> createState() => _ResidenceDetailState();
}

class _ResidenceDetailState extends State<ResidenceDetail> {
  final _service = ResidenceService();
  final _globService = GlobalInfoService();

  GlobalInfo? _info;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    if (widget.residence.globId != null) {
      _info = await _globService.getById(widget.residence.globId!);
    }
    setState(() => _loading = false);
  }

  Future<void> _modifier() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidenceForm(residence: widget.residence),
      ),
    );

    if (updated == true) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _supprimer() async {
    await _service.delete(widget.residence.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Résidence supprimée")));

    Navigator.pop(context, true);
  }

  String _formatDate(DateTime? d) {
    if (d == null) return "—";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.residence.adresse),
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
                  _section("Adresse", widget.residence.adresse),
                  _section("Ville", widget.residence.ville),
                  _section("Province", widget.residence.province),
                  _section("Pays", widget.residence.pays),
                  _section("Commentaire", widget.residence.commentaire ?? "—"),
                  _section("Loyer", widget.residence.loyer?.toString() ?? "—"),

                  const Divider(height: 40),

                  _section("Début", _formatDate(_info?.debut)),
                  _section("Fin", _formatDate(_info?.fin)),
                ],
              ),
            ),
    );
  }

  Widget _section(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
