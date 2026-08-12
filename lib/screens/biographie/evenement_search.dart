// ============================================================
// FICHIER : lib/screens/biographie/evenement_search.dart
// Recherche Événement — Compact + DEBUG complet
// ============================================================

import 'package:flutter/material.dart';
import '../../models/evenement_model.dart';
import '../../services/evenement_service.dart';
import 'evenement_list.dart';
import 'evenement_detail.dart';

class EvenementSearch extends StatefulWidget {
  const EvenementSearch({super.key});

  @override
  State<EvenementSearch> createState() => _EvenementSearchState();
}

class _EvenementSearchState extends State<EvenementSearch> {
  final _idCtrl = TextEditingController();
  final _titreCtrl = TextEditingController();
  final _motCtrl = TextEditingController();

  String? _categorie;

  final _service = EvenementService();

  final List<String> _categories = [
    "Développement",
    "Orientation",
    "Formation",
    "Création",
    "Découverte",
    "Relation",
    "Santé",
    "Finance",
    "Projet",
    "Voyage",
    "Loisir",
    "Autre",
  ];

  // ------------------------------------------------------------
  // DEBUG UTILITAIRE
  // ------------------------------------------------------------
  void _debug(String msg, [dynamic data]) {
    print("DEBUG-SEARCH: $msg");
    if (data != null) print("DEBUG-SEARCH-DATA: $data");
  }

  @override
  void dispose() {
    _debug("dispose() → nettoyage contrôleurs");
    _idCtrl.dispose();
    _titreCtrl.dispose();
    _motCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR ID
  // ------------------------------------------------------------
  Future<void> _searchById() async {
    _debug("Recherche par ID → '${_idCtrl.text}'");

    if (_idCtrl.text.isEmpty) {
      _debug("ID vide → annulation");
      return;
    }

    final id = int.tryParse(_idCtrl.text);
    if (id == null) {
      _debug("ID invalide → '${_idCtrl.text}'");
      return;
    }

    final evt = await _service.getEvenementById(id);

    _debug("Résultat recherche ID", evt);

    if (!mounted) return;

    if (evt == null) {
      _showMessage("Aucun événement trouvé");
    } else {
      _debug("Navigation → détail événement id=${evt.id}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EvenementDetail(evt: evt, liste: [evt], index: 0),
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR TITRE
  // ------------------------------------------------------------
  Future<void> _searchByTitre() async {
    _debug("Recherche par titre → '${_titreCtrl.text}'");

    final list = await _service.searchEvenementsByTitre(_titreCtrl.text);

    _debug("Résultats recherche titre", list.length);

    if (!mounted) return;
    _handleListResult(list);
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR CATÉGORIE
  // ------------------------------------------------------------
  Future<void> _searchByCategorie() async {
    _debug("Recherche par catégorie → '${_categorie}'");

    if (_categorie == null) {
      _debug("Catégorie non sélectionnée");
      return;
    }

    final index = _categories.indexOf(_categorie!);

    _debug("Index catégorie = $index");

    final list = await _service.searchEvenementsByCategorie(index);

    _debug("Résultats recherche catégorie", list.length);

    if (!mounted) return;
    _handleListResult(list);
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR MOTS-CLÉS
  // ------------------------------------------------------------
  Future<void> _searchByKeywords() async {
    _debug("Recherche par mot-clé → '${_motCtrl.text}'");

    final list = await _service.searchEvenementsByKeywords(_motCtrl.text);

    _debug("Résultats recherche mot-clé", list.length);

    if (!mounted) return;
    _handleListResult(list);
  }

  // ------------------------------------------------------------
  // GESTION DES RÉSULTATS
  // ------------------------------------------------------------
  void _handleListResult(List<EvenementModel> list) {
    _debug("Analyse résultats → count=${list.length}");

    if (list.isEmpty) {
      _debug("Aucun résultat trouvé");
      _showMessage("Aucun résultat");
      return;
    }

    if (list.length == 1) {
      _debug("Un seul résultat → navigation détail id=${list.first.id}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EvenementDetail(evt: list.first, liste: list, index: 0),
        ),
      );
      return;
    }

    _debug("Plusieurs résultats → navigation liste");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EvenementList()),
    );
  }

  // ------------------------------------------------------------
  // MESSAGE
  // ------------------------------------------------------------
  void _showMessage(String msg) {
    _debug("Affichage message SnackBar → '$msg'");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    _debug("build() → affichage interface recherche");

    return Scaffold(
      appBar: AppBar(title: const Text("Recherche d’un événement")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Recherche par ID"),
            _input(_idCtrl, "ID"),
            _button("Rechercher", _searchById),

            const Divider(height: 40),

            _sectionTitle("Recherche par titre"),
            _input(_titreCtrl, "Titre"),
            _button("Rechercher", _searchByTitre),

            const Divider(height: 40),

            _sectionTitle("Recherche par catégorie"),
            DropdownButtonFormField<String>(
              value: _categorie,
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) {
                _debug("Catégorie sélectionnée → '$v'");
                setState(() => _categorie = v);
              },
              decoration: _inputDecoration("Catégorie"),
            ),
            _button("Rechercher", _searchByCategorie),

            const Divider(height: 40),

            _sectionTitle("Recherche par mot-clé"),
            _input(_motCtrl, "Mot-clé"),
            _button("Rechercher", _searchByKeywords),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // WIDGETS UTILITAIRES
  // ------------------------------------------------------------
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: ctrl, decoration: _inputDecoration(label)),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    );
  }

  Widget _button(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(onPressed: onPressed, child: Text(label)),
      ),
    );
  }
}
