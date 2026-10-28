// ssc1_app/lib/screens/acquisition/acquisition_list.dart
//
// Écran : Liste des acquisitions (version SSC1)
// ---------------------------------------------
// - Recherche ID + titre
// - Tri chronologique via glob_info
// - Prix avant Nom (format 999999.00$)
// ----------------------------------------------

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/acquisition_model.dart';
import '../../models/global_info_model.dart';

import '../../services/acquisition_service.dart';
import '../../services/global_info_service.dart';

import '../../pdf/acquisition_liste_pdf.dart';
import '../../utils/pdf_saver.dart';

import 'acquisition_detail.dart';
import 'acquisition_form.dart';

import '../biographie/dialogs/recherche_titre_dialog.dart';

class AcquisitionList extends StatefulWidget {
  const AcquisitionList({super.key});

  @override
  State<AcquisitionList> createState() => _AcquisitionListState();
}

class _AcquisitionListState extends State<AcquisitionList> {
  final _service = AcquisitionService();
  final _globService = GlobalInfoService();

  final _idCtrl = TextEditingController();

  List<AcquisitionModel> _items = [];
  List<AcquisitionModel> _currentList = [];

  Map<int, GlobalInfo?> _globMap = {};

  String? _critereActuel = "Tous";

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _items = await _service.getAllAcquisitions();

    _globMap.clear();
    for (var a in _items) {
      if (a.globId != null) {
        final info = await _globService.getById(a.globId!);
        _globMap[a.id!] = info;
      }
    }

    _currentList = List.from(_items);
    _critereActuel = "Tous";

    setState(() => _loading = false);
  }

  Future<void> _popup(String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";
    return "${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}";
  }

  String _fmtPrix(double? p) {
    if (p == null) return "-";
    return "${p.toStringAsFixed(2)}\$";
  }

  // Générer PDF liste (sera ajusté demain)
  Future<void> _genererPDFListe() async {
    try {
      final data = _currentList.map((a) {
        final info = _globMap[a.id];
        return {
          "id": a.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "prix": _fmtPrix(a.prix),
          "nom": a.nom,
        };
      }).toList();

      final bytes = await AcquisitionListePdf.generate(
        data,
        "Liste des acquisitions",
        critere: _critereActuel,
      );

      final path = await savePdf(bytes: bytes, baseName: "ssc1_acquisition");

      _popup("PDF généré :\n$path");
    } catch (e) {
      _popup("Erreur PDF");
    }
  }

  Future<void> _ouvrirPDFListe() async {
    try {
      final ok = await openSavedPdf();
      if (!ok) _popup("Aucun PDF trouvé");
    } catch (e) {
      _popup("Erreur ouverture PDF");
    }
  }

  Future<void> _imprimerPDF() async {
    try {
      final data = _currentList.map((a) {
        final info = _globMap[a.id];
        return {
          "id": a.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "prix": _fmtPrix(a.prix),
          "nom": a.nom,
        };
      }).toList();

      final bytes = await AcquisitionListePdf.generate(
        data,
        "Liste des acquisitions",
        critere: _critereActuel,
      );

      await Printing.layoutPdf(onLayout: (_) => bytes);
    } catch (e) {
      _popup("Erreur impression");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Accueil",
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Acquisitions"),
        actions: [
          IconButton(
            tooltip: "Ajouter",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final updated = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  child: SizedBox(width: 420, child: const AcquisitionForm()),
                ),
              );
              if (updated == true) {
                await _charger();
                _reappliquerFiltre();
              }
            },
          ),

          IconButton(
            tooltip: "Tout",
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _idCtrl.clear();
              _charger();
            },
          ),

          SizedBox(
            width: 50,
            child: TextField(
              controller: _idCtrl,
              maxLength: 4,
              decoration: const InputDecoration(
                counterText: "",
                hintText: "ID",
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          IconButton(
            tooltip: "Recherche ID",
            icon: const Icon(Icons.search),
            onPressed: _searchById,
          ),

          IconButton(
            tooltip: "Recherche par titre",
            icon: const Icon(Icons.title),
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => RechercheTitreDialog(
                  onSearch: (titre) async {
                    final liste = await _service.searchAcquisitionsByTitre(
                      titre,
                    );
                    if (liste.isEmpty) {
                      _popup("Aucun résultat");
                      return;
                    }

                    _currentList = liste;
                    _critereActuel = "Titre contient $titre";
                    setState(() {});
                  },
                ),
              );
            },
          ),

          IconButton(
            tooltip: "Générer PDF",
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _genererPDFListe,
          ),

          IconButton(
            tooltip: "Ouvrir PDF",
            icon: const Icon(Icons.open_in_new),
            onPressed: _ouvrirPDFListe,
          ),

          IconButton(
            tooltip: "Imprimer PDF",
            icon: const Icon(Icons.print),
            onPressed: _imprimerPDF,
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentList.isEmpty
          ? const Center(child: Text("Aucune acquisition"))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_critereActuel != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Filtre : $_critereActuel",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // HEADER DES COLONNES
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 40,
                        child: Text(
                          "ID",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Début",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: Text(
                          "Fin",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 40,
                        child: Text(
                          "Type",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: Text(
                          "Prix",
                          style: TextStyle(
                            fontFamily: "RobotoMono",
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Nom",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _currentList.length,
                    itemBuilder: (_, i) {
                      final a = _currentList[i];
                      final info = _globMap[a.id];

                      final id4 = a.id.toString().padLeft(4, ' ');
                      final debut = _fmt(info?.debut);
                      final fin = _fmt(info?.fin);
                      final type = (info?.type ?? "-").padRight(4);
                      final prix = _fmtPrix(a.prix);

                      return GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AcquisitionDetail(
                                liste: [a],
                                index: 0,
                                critere: null,
                              ),
                            ),
                          );
                          if (updated == true) {
                            await _charger();
                            _reappliquerFiltre();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  id4,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  debut,
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  fin == "-" ? "          " : fin,
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 40,
                                child: Text(
                                  type,
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  prix,
                                  style: const TextStyle(
                                    fontFamily: "RobotoMono",
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  a.nom,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          child: const Text("Quitter"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _reappliquerFiltre() {
    if (_critereActuel == null || _critereActuel == "Tous") {
      _currentList = List.from(_items);
      return;
    }

    if (_critereActuel!.startsWith("Titre contient")) {
      final mot = _critereActuel!.substring("Titre contient ".length);
      _currentList = _items.where((a) => a.nom.contains(mot)).toList();
    }
  }

  Future<void> _searchById() async {
    final txt = _idCtrl.text.trim();
    if (txt.isEmpty) return;

    final id = int.tryParse(txt);
    if (id == null) {
      _popup("ID invalide");
      return;
    }

    final acq = await _service.getAcquisitionById(id);

    if (acq == null) {
      _popup("Aucun résultat");
      return;
    }

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AcquisitionDetail(liste: [acq], index: 0, critere: null),
      ),
    );

    if (updated == true) {
      await _charger();
      _reappliquerFiltre();
    }
  }
}
