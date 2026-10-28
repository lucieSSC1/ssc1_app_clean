// ============================================================
// FICHIER : lib/screens/biographie/evenement_list.dart
// Version SSC1 — Liste principale alignée en colonnes fixes
// Interligne réduit sérieusement (sans toucher à la hauteur de ligne)
// Boîtes de dialogue NON dismissibles (barrierDismissible: false)
// ============================================================

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../models/event_categ_model.dart';

import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../services/event_categ_service.dart';

import '../../pdf/chronologie_pdf.dart';
import '../../utils/pdf_saver.dart';

import 'evenement_detail.dart';
import 'evenement_form.dart';

import 'dialogs/recherche_titre_dialog.dart';
import 'dialogs/recherche_categorie_dialog.dart';
import 'dialogs/recherche_keywords_dialog.dart';

class EvenementList extends StatefulWidget {
  const EvenementList({super.key});

  @override
  State<EvenementList> createState() => _EvenementListState();
}

class _EvenementListState extends State<EvenementList> {
  final _service = EvenementService();
  final _globService = GlobalInfoService();
  final _catService = EventCategService();

  final _idCtrl = TextEditingController();

  List<EvenementModel> _items = [];
  List<EvenementModel> _currentList = [];

  Map<int, GlobalInfo?> _globMap = {};
  List<EventCateg> _categories = [];

  String? _critereActuel = "Tous";

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _items = await _service.getAllEvenements();
    _categories = await _catService.getAll();

    _globMap.clear();
    for (var e in _items) {
      if (e.globId != null) {
        final info = await _globService.getById(e.globId!);
        _globMap[e.globId!] = info;
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

  // ⭐ Nouveau : Générer PDF (sans ouvrir)
  Future<void> _genererPDFListe() async {
    try {
      final data = _currentList.map((e) {
        final info = _globMap[e.globId];
        return {
          "id": e.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "nom": e.nom,
        };
      }).toList();

      final bytes = await ChronologiePdf.generate(
        data,
        "Liste des evenements",
        critere: _critereActuel,
      );

      final path = await savePdf(bytes: bytes, baseName: "ssc1_evenement");

      _popup("PDF généré :\n$path");
    } catch (e) {
      _popup("Erreur PDF");
    }
  }

  // ⭐ Nouveau : Ouvrir PDF déjà généré
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
      final data = _currentList.map((e) {
        final info = _globMap[e.globId];
        return {
          "id": e.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "nom": e.nom,
        };
      }).toList();

      final bytes = await ChronologiePdf.generate(
        data,
        "Liste des evenements",
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
        title: const Text("Evenements"),
        actions: [
          IconButton(
            tooltip: "Ajouter",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final updated = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  child: SizedBox(width: 420, child: const EvenementForm()),
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
                    final liste = await _service.searchEvenementsByTitre(titre);
                    if (liste.isEmpty) {
                      _popup("Aucun resultat");
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
            tooltip: "Recherche par categorie",
            icon: const Icon(Icons.category),
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => RechercheCategorieDialog(
                  categories: _categories,
                  onSearch: (catId) async {
                    final liste = await _service.searchEvenementsByCategorie(
                      catId,
                    );

                    if (liste.isEmpty) {
                      _popup("Aucun resultat");
                      return;
                    }

                    final catNom = _categories
                        .firstWhere((c) => c.id == catId)
                        .nom;

                    _currentList = liste;
                    _critereActuel = "Categorie = $catNom";
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
                    final liste = await _service.searchEvenementsByKeywordsEtOu(
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

                    final crit = modeEt
                        ? "Mots-cles (ET, ${rechercheExacte ? "Exacte" : "Partielle"}) : $mc1 $mc2 $mc3"
                        : "Mots-cles (OU, ${rechercheExacte ? "Exacte" : "Partielle"}) : $mc1 $mc2 $mc3";

                    _currentList = liste;
                    _critereActuel = crit;
                    setState(() {});
                  },
                ),
              );
            },
          ),

          // ⭐ Nouveau : Générer PDF (sans ouvrir)
          IconButton(
            tooltip: "Generer PDF",
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _genererPDFListe,
          ),

          // ⭐ Nouveau : Ouvrir PDF
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
          ? const Center(child: Text("Aucun evenement"))
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

                // ⭐ HEADER DES COLONNES
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
                      final e = _currentList[i];
                      final info = _globMap[e.globId];

                      final id4 = e.id.toString().padLeft(4, ' ');
                      final debut = _fmt(info?.debut);
                      final fin = _fmt(info?.fin);
                      final type = (info?.type ?? "-").padRight(4);

                      return GestureDetector(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EvenementDetail(
                                liste: [e],
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
                              Expanded(
                                child: Text(
                                  e.nom,
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
      _currentList = _items.where((e) => e.nom.contains(mot)).toList();
    }

    if (_critereActuel!.startsWith("Categorie =")) {
      final catNom = _critereActuel!.substring("Categorie = ".length);
      final cat = _categories.firstWhere((c) => c.nom == catNom);
      _currentList = _items.where((e) => e.categorie == cat.id).toList();
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

    final evt = await _service.getEvenementById(id);

    if (evt == null) {
      _popup("Aucun resultat");
      return;
    }

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvenementDetail(liste: [evt], index: 0, critere: null),
      ),
    );

    if (updated == true) {
      await _charger();
      _reappliquerFiltre();
    }
  }
}
