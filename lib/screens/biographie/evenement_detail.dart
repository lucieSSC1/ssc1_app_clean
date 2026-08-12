// ============================================================
// FICHIER : lib/screens/biographie/evenement_detail.dart
// Détail Événement — Compact + Navigation + DEBUG complet
// ============================================================

import 'package:flutter/material.dart';

import '../../models/evenement_model.dart';
import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../models/global_info_model.dart';

import '../../services/event_categ_service.dart';
import '../../models/event_categ_model.dart';

class EvenementDetail extends StatefulWidget {
  final EvenementModel evt;
  final List<EvenementModel> liste;
  final int index;

  const EvenementDetail({
    super.key,
    required this.evt,
    required this.liste,
    required this.index,
  });

  @override
  State<EvenementDetail> createState() => _EvenementDetailState();
}

class _EvenementDetailState extends State<EvenementDetail> {
  final _evtService = EvenementService();
  final _globService = GlobalInfoService();
  final _catService = EventCategService();

  GlobalInfo? _info;
  Map<int, String> _catMap = {};

  bool _loading = true;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-DETAIL: $msg");
    if (data != null) print("DEBUG-DETAIL-DATA: $data");
  }

  @override
  void initState() {
    super.initState();
    _debug("initState() → appel _charger()");
    _charger();
  }

  Future<void> _charger() async {
    _debug("_charger() → evt.id=${widget.evt.id}, globId=${widget.evt.globId}");

    // Charger GlobalInfo
    if (widget.evt.globId != null) {
      _debug("Chargement GlobalInfo pour globId=${widget.evt.globId}");
      _info = await _globService.getById(widget.evt.globId!);
      _debug("GlobalInfo reçu", _info);
    }

    // Charger catégories
    final cats = await _catService.getAll();
    _catMap = {for (var c in cats) c.id: c.nom};

    setState(() => _loading = false);
  }

  // ------------------------------------------------------------
  // SUPPRESSION
  // ------------------------------------------------------------
  Future<void> _supprimer() async {
    if (widget.evt.id == null) {
      _debug("Suppression annulée : id null");
      return;
    }

    _debug("Suppression événement id=${widget.evt.id}");

    await _evtService.deleteEvenement(widget.evt.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Événement supprimé")));

    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // FORMATAGE DATES
  // ------------------------------------------------------------
  String _format(DateTime? d) {
    if (d == null) return "—";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final e = widget.evt;
    final catNom = _catMap[e.categorie] ?? "—";

    _debug("build() → affichage événement id=${e.id}, index=${widget.index}");

    return Scaffold(
      appBar: AppBar(
        title: Text(e.nom),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _supprimer),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      _ligne("ID", "${e.id}"),
                      _ligne("Début", _format(_info?.debut)),
                      _ligne("Fin", _format(_info?.fin)),
                      _ligne("Type", _info?.type ?? "—"),
                      _ligne("Catégorie", catNom),
                      _ligne("Nom", e.nom),
                      _ligne("Mot clé 1", e.motCle1 ?? "—"),
                      _ligne("Mot clé 2", e.motCle2 ?? "—"),
                      _ligne("Mot clé 3", e.motCle3 ?? "—"),
                      _ligne("Description", e.description ?? "—"),
                      const SizedBox(height: 20),
                      _navigation(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // ------------------------------------------------------------
  // WIDGETS
  // ------------------------------------------------------------
  Widget _ligne(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _navigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: () => _ouvrirIndex(0),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _ouvrirIndex(widget.index - 1),
        ),
        Text("${widget.index + 1} / ${widget.liste.length}"),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _ouvrirIndex(widget.index + 1),
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: () => _ouvrirIndex(widget.liste.length - 1),
        ),
      ],
    );
  }

  void _ouvrirIndex(int i) {
    if (i < 0 || i >= widget.liste.length) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => EvenementDetail(
          evt: widget.liste[i],
          liste: widget.liste,
          index: i,
        ),
      ),
    );
  }
}
