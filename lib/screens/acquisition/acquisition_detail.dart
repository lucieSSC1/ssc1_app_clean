// ssc1_app/lib/screens/acquisition/acquisition_detail.dart
//
// Fiche : Acquisition (version SSC1)
// ----------------------------------
// - Fiche officielle
// - Modifier
// - Supprimer (cascade glob_info)
// - Imprimer PDF individuel
// - Vendeur affiché seulement (N/A si aucun)
// ----------------------------------

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/acquisition_model.dart';
import '../../models/global_info_model.dart';
import '../../models/vendeur_model.dart';
import '../../models/maintenance_model.dart'; //ICI

import '../../services/acquisition_service.dart';
import '../../services/global_info_service.dart';
import '../../services/vendeur_service.dart';
import '../../services/maintenance_service.dart'; //ICI
import '../../services/storage_service.dart';

import '../../pdf/acquisition_fiche_pdf.dart';
import 'acquisition_form.dart';
import '../maintenance/maintenance_form.dart'; //ICI

class AcquisitionDetail extends StatefulWidget {
  final List<AcquisitionModel> liste;
  final int index;
  final String? critere;

  const AcquisitionDetail({
    super.key,
    required this.liste,
    required this.index,
    this.critere,
  });

  @override
  State<AcquisitionDetail> createState() => _AcquisitionDetailState();
}

class _AcquisitionDetailState extends State<AcquisitionDetail> {
  final _acqService = AcquisitionService();
  final _globService = GlobalInfoService();
  final _vendService = VendeurService();
  final _maintService = MaintenanceService(); //ICI
  final _storageService = StorageService();

  GlobalInfo? _info;
  Vendeur? _vendeur;
  List<MaintenanceModel> _maintenances = []; //ICI

  bool _loading = true;
  late int _pos;

  AcquisitionModel? _acq;

  @override
  void initState() {
    super.initState();
    _pos = widget.index;
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);

    final idToLoad = _acq?.id ?? widget.liste[_pos].id!;
    _acq = await _acqService.getAcquisitionById(idToLoad);

    if (_acq!.globId != null) {
      _info = await _globService.getById(_acq!.globId!);
    }

    if (_acq!.vendeurId != null) {
      _vendeur = await _vendService.getById(_acq!.vendeurId!);
    }
    _maintenances = await _maintService.getByAcquisition(_acq!.id!);

    setState(() => _loading = false);
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  String _fmtPrix(double? p) {
    if (p == null) return "-";
    return "${p.toStringAsFixed(2)}\$";
  }

  // ------------------------------------------------------------
  // OUVRIR IMAGE
  // ------------------------------------------------------------
  Future<void> _ouvrirImage() async {
    final acq = _acq;

    if (acq == null || acq.image == null || acq.image!.isEmpty) {
      return;
    }

    final fileName = acq.image!.replaceFirst('image/', '');

    await _storageService.openStorageFile(bucket: 'image', fileName: fileName);
  }

  // ------------------------------------------------------------
  // OUVRIR FACTURE
  // ------------------------------------------------------------
  Future<void> _ouvrirFacture() async {
    final acq = _acq;

    if (acq == null || acq.facture == null || acq.facture!.isEmpty) {
      return;
    }

    final fileName = acq.facture!.replaceFirst('facture/', '');

    await _storageService.openStorageFile(
      bucket: 'facture',
      fileName: fileName,
    );
  }

  // ------------------------------------------------------------
  // SAUVEGARDER IMAGE
  // ------------------------------------------------------------
  Future<void> _sauvegarderImage() async {
    final acq = _acq;

    if (acq == null || acq.image == null || acq.image!.isEmpty) {
      return;
    }

    final fileName = acq.image!.replaceFirst('image/', '');

    await _storageService.saveStorageFile(bucket: 'image', fileName: fileName);
  }

  // ------------------------------------------------------------
  // SAUVEGARDER FACTURE
  // ------------------------------------------------------------
  Future<void> _sauvegarderFacture() async {
    final acq = _acq;

    if (acq == null || acq.facture == null || acq.facture!.isEmpty) {
      return;
    }

    final fileName = acq.facture!.replaceFirst('facture/', '');

    await _storageService.saveStorageFile(
      bucket: 'facture',
      fileName: fileName,
    );
  }

  // MULTIPLATEFORME
  // Validation Windows effectuée.
  // Test réel Android, iOS et macOS requis.

  // ------------------------------------------------------------
  // IMPRIMER PDF INDIVIDUEL
  // ------------------------------------------------------------
  Future<void> _imprimerPDFIndividuel() async {
    if (_acq == null) return;

    final acq = _acq!;
    final info = _info;

    final dataAcq = {
      "id": acq.id,
      "nom": acq.nom,
      "description": acq.description ?? "",
      "vendeur": _vendeur?.nom ?? "N/A",
      "garantie": acq.garantie ?? "",
      "expire": _fmt(acq.expire),
      "prix": _fmtPrix(acq.prix),
      "commentaire": acq.commentaire ?? "",
      "image": acq.image ?? "",
      "facture": acq.facture ?? "",
    };

    final dataGlob = info == null
        ? null
        : {
            "debut": _fmt(info.debut),
            "fin": _fmt(info.fin),
            "type": info.type ?? "-",
          };

    final dataMaint = _maintenances.map((m) {
      return {
        "date": _fmt(m.date),
        "aEffectuer": m.aEffectuer ?? "",
        "reparateur": m.reparateur ?? "",
        "effectue": m.effectue ?? "",
        "duree": m.duree?.toString() ?? "",
        "pieces": m.pieces?.toString() ?? "",
        "cout": m.cout?.toStringAsFixed(2) ?? "",
      };
    }).toList();

    final bytes = await AcquisitionFichePdf.generate(
      acq: dataAcq,
      glob: dataGlob,
      maintenances: dataMaint,
    );

    await Printing.layoutPdf(onLayout: (_) => bytes);
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final acq = _acq!;
    final info = _info;
    final vendeurNom = _vendeur?.nom ?? "N/A";

    final bool ficheOfficielle = (widget.critere == null);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text("Fiche acquisition"),
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
                    child: SizedBox(
                      width: 420,
                      child: AcquisitionForm(acq: acq),
                    ),
                  ),
                );

                if (updated == true) {
                  await _charger();
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
                    content: Text("Supprimer ${acq.nom} ?"),
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
                  await _acqService.deleteAcquisition(acq.id!);
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

                // ORDRE FINAL
                _ligne("ID", "${acq.id}"),
                _ligne("Début", _fmt(info?.debut)),
                _ligne("Fin", _fmt(info?.fin)),
                _ligne("Type", info?.type ?? "-"),
                _ligne("Nom", acq.nom),

                // PRIX
                _ligne("Prix", _fmtPrix(acq.prix)),

                // Vendeur (nom) — Option 3
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text(
                        "Vendeur",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Text(" : "),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        vendeurNom,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // DESCRIPTION
                _blocTexte("Description", acq.description ?? ""),

                // MAINTENANCE
                if (_maintenances.isNotEmpty)
                  const Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "Maintenance",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                if (_maintenances.isEmpty)
                  Row(
                    children: const [
                      SizedBox(
                        width: 100,
                        child: Text(
                          "Maintenance",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(" : "),
                      Text("N/A"),
                    ],
                  ),

                if (_maintenances.isNotEmpty)
                  ..._maintenances.asMap().entries.map((entry) {
                    final no = entry.key + 1;
                    final m = entry.value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Intervention #$no"),

                          Text(_fmt(m.date)),

                          Text("À effectuer : ${m.aEffectuer ?? "-"}"),

                          Text("Réparateur : ${m.reparateur ?? "-"}"),

                          Text("Effectué : ${m.effectue ?? "-"}"),

                          Text("Coût : ${m.cout?.toStringAsFixed(2) ?? "-"}\$"),
                        ],
                      ),
                    );
                  }),

                _ligne("Garantie", acq.garantie ?? "-"),
                _ligne("Expire", _fmt(acq.expire)),

                // IMAGE
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Image",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Flexible(
                        child: Text(
                          acq.image ?? "-",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      if (acq.image != null && acq.image!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          tooltip: "Ouvrir",
                          onPressed: _ouvrirImage,
                        ),

                      IconButton(
                        icon: const Icon(Icons.save_alt),
                        tooltip: "Sauvegarder",
                        onPressed: _sauvegarderImage,
                      ),
                    ],
                  ),
                ),

                // FACTURE
                // FACTURE
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Facture",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      Flexible(
                        child: Text(
                          acq.facture ?? "-",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      if (acq.facture != null && acq.facture!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          tooltip: "Ouvrir",
                          onPressed: _ouvrirFacture,
                        ),

                      IconButton(
                        icon: const Icon(Icons.save_alt),
                        tooltip: "Sauvegarder",
                        onPressed: _sauvegarderFacture,
                      ),
                    ],
                  ),
                ),

                // COMMENTAIRE
                _blocTexte("Commentaire", acq.commentaire ?? ""),
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

  Widget _blocTexte(String label, String value) {
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
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: SingleChildScrollView(child: Text(value)),
            ),
          ),
        ],
      ),
    );
  }
}
