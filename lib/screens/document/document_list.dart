// ============================================================
// FICHIER : lib/screens/document/document_list.dart
// Version SSC1 — Liste Documents
// ============================================================

import 'package:flutter/material.dart';

import '../../models/document_model.dart';
import '../../models/global_info_model.dart';

import '../../services/document_service.dart';
import '../../services/global_info_service.dart';

import '../biographie/dialogs/recherche_titre_dialog.dart';
import '../biographie/dialogs/recherche_keywords_dialog.dart';

import 'document_detail.dart';
import 'document_form.dart';

import 'package:printing/printing.dart';

import '../../pdf/document_liste_pdf.dart';
import '../../utils/pdf_saver.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  final _service = DocumentService();
  final _globService = GlobalInfoService();

  final _idCtrl = TextEditingController();

  List<DocumentModel> _items = [];
  List<DocumentModel> _currentList = [];

  Map<int, GlobalInfo?> _globMap = {};

  String? _critereActuel = "Tous";

  bool _loading = true;

  String _modeRecherche = "Tous";

  String _titreRecherche = "";

  String _mc1Recherche = "";
  String _mc2Recherche = "";
  String _mc3Recherche = "";

  bool _modeEtRecherche = false;
  bool _rechercheExacte = false;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _loading = true;

    _items = await _service.getAllDocuments();

    _globMap.clear();

    for (var doc in _items) {
      if (doc.globId != null) {
        final info = await _globService.getById(doc.globId!);

        _globMap[doc.globId!] = info;
      }
    }

    _currentList = List.from(_items);

    _critereActuel = "Tous";

    setState(() {
      _loading = false;
    });
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

    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _genererPDFListe() async {
    try {
      final data = _currentList.map((doc) {
        final info = _globMap[doc.globId];

        return {
          "id": doc.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "titre": doc.titre,
        };
      }).toList();

      final bytes = await DocumentListePdf.generate(
        data,
        "Liste des documents",
        critere: _critereActuel,
      );

      final path = await savePdf(bytes: bytes, baseName: "ssc1_document");

      _popup("PDF généré :\n$path");
    } catch (e) {
      _popup("Erreur PDF");
    }
  }

  Future<void> _ouvrirPDFListe() async {
    try {
      final ok = await openSavedPdf();

      if (!ok) {
        _popup("Aucun PDF trouvé");
      }
    } catch (e) {
      _popup("Erreur ouverture PDF");
    }
  }

  Future<void> _imprimerPDF() async {
    try {
      final data = _currentList.map((doc) {
        final info = _globMap[doc.globId];

        return {
          "id": doc.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "titre": doc.titre,
        };
      }).toList();

      final bytes = await DocumentListePdf.generate(
        data,
        "Liste des documents",
        critere: _critereActuel,
      );

      await Printing.layoutPdf(onLayout: (_) => bytes);
    } catch (e) {
      _popup("Erreur impression");
    }
  }

  Future<void> _rechargerCritereActuel() async {
    switch (_modeRecherche) {
      case "Titre":
        _currentList = await _service.searchDocumentsByTitre(_titreRecherche);
        break;

      case "MotsCles":
        _currentList = await _service.searchDocumentsByKeywordsEtOu(
          _mc1Recherche,
          _mc2Recherche,
          _mc3Recherche,
          _modeEtRecherche,
          _rechercheExacte,
        );
        break;

      default:
        await _charger();
        return;
    }

    setState(() {});
  }

  Future<void> _searchById() async {
    final txt = _idCtrl.text.trim();

    if (txt.isEmpty) return;

    final id = int.tryParse(txt);

    if (id == null) {
      _popup("ID invalide");
      return;
    }

    final doc = await _service.getDocumentById(id);

    if (doc == null) {
      _popup("Aucun résultat");
      return;
    }

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetail(liste: [doc], index: 0, critere: null),
      ),
    );

    if (updated == true) {
      await _rechargerCritereActuel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Documents"),
        actions: [
          IconButton(
            tooltip: "Ajouter",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final updated = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  child: SizedBox(width: 420, child: const DocumentForm()),
                ),
              );

              if (updated == true) {
                await _charger();
              }
            },
          ),

          IconButton(
            tooltip: "Tout",
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              _idCtrl.clear();

              _modeRecherche = "Tous";

              _titreRecherche = "";

              _mc1Recherche = "";
              _mc2Recherche = "";
              _mc3Recherche = "";

              _modeEtRecherche = false;
              _rechercheExacte = false;

              _critereActuel = "Tous";

              await _charger();
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
                    final liste = await _service.searchDocumentsByTitre(titre);

                    if (liste.isEmpty) {
                      _popup("Aucun resultat");
                      return;
                    }

                    _currentList = liste;

                    _modeRecherche = "Titre";
                    _titreRecherche = titre;

                    _critereActuel = "Titre contient $titre";

                    setState(() {});
                  },
                ),
              );
            },
          ),

          IconButton(
            tooltip: "Recherche mots-cles",
            icon: const Icon(Icons.text_snippet),
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => RechercheKeywordsDialog(
                  onSearch: (mc1, mc2, mc3, modeEt, rechercheExacte) async {
                    final liste = await _service.searchDocumentsByKeywordsEtOu(
                      mc1,
                      mc2,
                      mc3,
                      modeEt,
                      rechercheExacte,
                    );

                    if (liste.isEmpty) {
                      _popup("Aucun resultat");
                      return;
                    }

                    final crit = modeEt ? "Mots-cles (ET)" : "Mots-cles (OU)";

                    _currentList = liste;
                    _modeRecherche = "MotsCles";

                    _mc1Recherche = mc1;
                    _mc2Recherche = mc2;
                    _mc3Recherche = mc3;

                    _modeEtRecherche = modeEt;
                    _rechercheExacte = rechercheExacte;

                    _critereActuel = crit;

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
          ? const Center(child: Text("Aucun document"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 40,
                        child: Text("ID", textAlign: TextAlign.right),
                      ),
                      SizedBox(width: 8),

                      SizedBox(width: 80, child: Text("Début")),
                      SizedBox(width: 8),

                      SizedBox(width: 80, child: Text("Fin")),
                      SizedBox(width: 8),

                      SizedBox(width: 40, child: Text("Type")),
                      SizedBox(width: 8),

                      Expanded(child: Text("Titre")),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _currentList.length,
                    itemBuilder: (_, i) {
                      final doc = _currentList[i];

                      final info = _globMap[doc.globId];

                      return InkWell(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentDetail(
                                liste: [doc],
                                index: 0,
                                critere: null,
                              ),
                            ),
                          );

                          if (updated == true) {
                            await _rechargerCritereActuel();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  "${doc.id}",
                                  textAlign: TextAlign.right,
                                ),
                              ),

                              const SizedBox(width: 8),

                              SizedBox(
                                width: 80,
                                child: Text(_fmt(info?.debut)),
                              ),

                              const SizedBox(width: 8),

                              SizedBox(width: 80, child: Text(_fmt(info?.fin))),

                              const SizedBox(width: 8),

                              SizedBox(
                                width: 40,
                                child: Text(info?.type ?? "DOC"),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  doc.titre,
                                  overflow: TextOverflow.ellipsis,
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
          onPressed: () => Navigator.pop(context),
          child: const Text("Quitter"),
        ),
      ),
    );
  }
}
