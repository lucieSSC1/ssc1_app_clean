// ============================================================
// FICHIER : lib/screens/biographie/evenement_detail.dart
// Version SSC1 — Fiche officielle + Modifier + Supprimer + Imprimer PDF
// ============================================================

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../services/event_categ_service.dart';

import '../../pdf/fiche_pdf.dart';
import 'evenement_form.dart';

class EvenementDetail extends StatefulWidget {
  final List<EvenementModel> liste;
  final int index;
  final String? critere;

  const EvenementDetail({
    super.key,
    required this.liste,
    required this.index,
    this.critere,
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
  late int _pos;

  EvenementModel? _evt;

  @override
  void initState() {
    super.initState();
    _pos = widget.index;
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);

    final idToLoad = _evt?.id ?? widget.liste[_pos].id!;
    _evt = await _evtService.getEvenementById(idToLoad);

    if (_evt!.globId != null) {
      _info = await _globService.getById(_evt!.globId!);
    } else {
      _info = null;
    }

    final cats = await _catService.getAll();
    _catMap = {for (var c in cats) c.id: c.nom};

    setState(() => _loading = false);
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  // ------------------------------------------------------------
  // IMPRIMER PDF INDIVIDUEL
  // ------------------------------------------------------------
  Future<void> _imprimerPDFIndividuel() async {
    if (_evt == null) return;

    final evt = _evt!;
    final info = _info;

    final dataEvt = {
      "id": evt.id,
      "nom": evt.nom,
      "categorie": _catMap[evt.categorie] ?? "-",
      "motCle1": evt.motCle1 ?? "",
      "motCle2": evt.motCle2 ?? "",
      "motCle3": evt.motCle3 ?? "",
      "description": evt.description ?? "",
    };

    final dataGlob = info == null
        ? null
        : {
            "debut": _fmt(info.debut),
            "fin": _fmt(info.fin),
            "type": info.type ?? "-",
          };

    final bytes = await FichePdf.generate(
      evt: dataEvt,
      glob: dataGlob,
      critere: widget.critere,
    );

    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final evt = _evt!;
    final info = _info;
    final catNom = _catMap[evt.categorie] ?? "";

    final bool ficheOfficielle = (widget.critere == null);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Fiche événement"),
        actions: [
          if (ficheOfficielle)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Modifier",
              onPressed: () async {
                final updated = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Dialog(
                    child: SizedBox(width: 420, child: EvenementForm(evt: evt)),
                  ),
                );

                if (updated == true) {
                  final freshEvt = await _evtService.getEvenementById(
                    _evt!.id!,
                  );
                  _evt = freshEvt;

                  if (_evt!.globId != null) {
                    _info = await _globService.getById(_evt!.globId!);
                  }

                  final cats = await _catService.getAll();
                  _catMap = {for (var c in cats) c.id: c.nom};

                  setState(() {});
                }
              },
            ),

          if (ficheOfficielle)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Supprimer",
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: const Text("Supprimer"),
                    content: Text("Supprimer ${evt.nom} ?"),
                    actions: [
                      ElevatedButton(
                        child: const Text("Supprimer"),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                      ElevatedButton(
                        child: const Text("Annuler"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _evtService.deleteEvenement(evt.id!);
                  if (!mounted) return;
                  Navigator.pop(context, true);
                }
              },
            ),

          IconButton(
            icon: const Icon(Icons.print),
            tooltip: "Imprimer PDF",
            onPressed: _imprimerPDFIndividuel,
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
                if (widget.critere != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Critère : ${widget.critere}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                _ligne("ID", "${evt.id}"),
                _ligne("Début", _fmt(info?.debut)),
                _ligne("Fin", _fmt(info?.fin)),

                // ⭐ NOM juste sous FIN
                _ligne("Nom", evt.nom),

                _ligne("Type", info?.type ?? "-"),
                _ligne("Catégorie", catNom),
                _ligne("Mot clé 1", evt.motCle1 ?? ""),
                _ligne("Mot clé 2", evt.motCle2 ?? ""),
                _ligne("Mot clé 3", evt.motCle3 ?? ""),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey.shade200,
                          child: SingleChildScrollView(
                            child: Text(evt.description ?? ""),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
