// ============================================================
// FICHIER : lib/screens/biographie/evenement_list.dart
// Version SSC1 — Liste principale + Loupe ID + Recherches
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
  Map<int, GlobalInfo?> _globMap = {};
  List<EventCateg> _categories = [];

  bool _loading = true;
  String? _lastPdfPath;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // CHARGER
  // ------------------------------------------------------------
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

    setState(() => _loading = false);
  }

  // ------------------------------------------------------------
  // POPUP
  // ------------------------------------------------------------
  Future<void> _popup(String msg) async {
    await showDialog(
      context: context,
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

  // ------------------------------------------------------------
  // LOUPE ID → FICHE OFFICIELLE + SUPPRIMER
  // ------------------------------------------------------------
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

    // ⭐ Fiche officielle avec Modifier + Supprimer
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvenementDetail(liste: [evt], index: 0, critere: null),
      ),
    );

    await _charger();
  }

  // ------------------------------------------------------------
  // RECHERCHES → LISTE SELON CRITÈRES (pas de supprimer ici)
  // ------------------------------------------------------------
  Future<void> _searchTitre() async {
    await showDialog(
      context: context,
      builder: (_) => RechercheTitreDialog(
        onSearch: (titre) async {
          final liste = await _service.searchEvenementsByTitre(titre);
          if (liste.isEmpty) {
            _popup("Aucun resultat");
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EvenementDetail(
                liste: liste,
                index: 0,
                critere: "Titre contient $titre",
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _searchCategorie() async {
    await showDialog(
      context: context,
      builder: (_) => RechercheCategorieDialog(
        categories: _categories,
        onSearch: (catId) async {
          final liste = await _service.searchEvenementsByCategorie(catId);

          if (liste.isEmpty) {
            _popup("Aucun resultat");
            return;
          }

          final catNom = _categories.firstWhere((c) => c.id == catId).nom;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EvenementDetail(
                liste: liste,
                index: 0,
                critere: "Categorie = $catNom",
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _searchMotsCles() async {
    await showDialog(
      context: context,
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

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  EvenementDetail(liste: liste, index: 0, critere: crit),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // FORMAT DATE dd-mm-yyyy
  // ------------------------------------------------------------
  String _fmt(DateTime? d) {
    if (d == null) return "-";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  // ------------------------------------------------------------
  // PDF — dd-mm-yyyy partout
  // ------------------------------------------------------------
  Future<void> _genererPDFListe() async {
    try {
      final data = _items.map((e) {
        final info = _globMap[e.globId];
        return {
          "id": e.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "nom": e.nom,
        };
      }).toList();

      final bytes = await ChronologiePdf.generate(data, "Liste des evenements");

      final path = await savePdf(bytes: bytes, baseName: "ssc1_evenement");

      _lastPdfPath = path;

      showPdfPopup(context, path);
    } catch (e) {
      _popup("Erreur PDF");
    }
  }

  Future<void> _ouvrirPDF() async {
    if (_lastPdfPath == null) {
      _popup("Aucun PDF genere");
      return;
    }
    await openPdf(_lastPdfPath!);
  }

  Future<void> _imprimerPDF() async {
    try {
      final data = _items.map((e) {
        final info = _globMap[e.globId];
        return {
          "id": e.id,
          "debut": _fmt(info?.debut),
          "fin": _fmt(info?.fin),
          "type": info?.type ?? "",
          "nom": e.nom,
        };
      }).toList();

      final bytes = await ChronologiePdf.generate(data, "Liste des evenements");

      await Printing.layoutPdf(onLayout: (_) => bytes);
    } catch (e) {
      _popup("Erreur impression");
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
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
                builder: (_) => Dialog(
                  child: SizedBox(width: 420, child: const EvenementForm()),
                ),
              );
              if (updated == true) _charger();
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
            onPressed: _searchTitre,
          ),

          IconButton(
            tooltip: "Recherche par categorie",
            icon: const Icon(Icons.category),
            onPressed: _searchCategorie,
          ),

          IconButton(
            tooltip: "Recherche mots-cles",
            icon: const Icon(Icons.text_snippet),
            onPressed: _searchMotsCles,
          ),

          IconButton(
            tooltip: "Generer PDF",
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _genererPDFListe,
          ),

          IconButton(
            tooltip: "Ouvrir PDF",
            icon: const Icon(Icons.open_in_new),
            onPressed: _ouvrirPDF,
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
          : _items.isEmpty
          ? const Center(child: Text("Aucun evenement"))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final e = _items[i];
                final info = _globMap[e.globId];

                final id4 = e.id.toString().padLeft(4, ' ');

                final debut = _fmt(info?.debut);
                final fin = _fmt(info?.fin);
                final type = info?.type ?? "-";

                return ListTile(
                  title: Text("$id4 | $debut -> $fin | $type | ${e.nom}"),
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
                    if (updated == true) _charger();
                  },
                );
              },
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
}
