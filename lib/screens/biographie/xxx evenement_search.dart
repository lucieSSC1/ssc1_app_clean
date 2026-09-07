// ============================================================
// FICHIER : lib/screens/biographie/evenement_search.dart
// 4 fenêtres individuelles de recherche SSC1
// ============================================================

import 'package:flutter/material.dart';
import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import 'evenement_detail.dart';

// ============================================================
// OUTIL : Liste compacte des résultats
// ============================================================

class ResultList extends StatelessWidget {
  final List<EvenementModel> items;
  final Map<int, GlobalInfo> globMap;

  const ResultList({super.key, required this.items, required this.globMap});

  String _fmt(DateTime? d) {
    if (d == null) return "";
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final e = items[i];
        final info = globMap[e.globId]!;

        return ListTile(
          title: Text(
            "${e.id} | ${_fmt(info.debut)} → ${_fmt(info.fin)} | ${info.type} | ${e.nom}",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EvenementDetail(evt: e, liste: items, index: i),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================
// 1. RECHERCHE PAR ID
// ============================================================

class SearchID extends StatefulWidget {
  const SearchID({super.key});

  @override
  State<SearchID> createState() => _SearchIDState();
}

class _SearchIDState extends State<SearchID> {
  final _idCtrl = TextEditingController();
  final _service = EvenementService();
  final _globService = GlobalInfoService();

  List<EvenementModel> _results = [];
  Map<int, GlobalInfo> _globMap = {};

  Future<void> _search() async {
    final id = int.tryParse(_idCtrl.text.trim());
    if (id == null) return;

    final evt = await _service.getEvenementById(id);
    if (evt == null) {
      setState(() => _results = []);
      return;
    }

    final info = await _globService.getById(evt.globId!);
    _globMap = {evt.globId!: info!};

    setState(() => _results = [evt]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche par ID")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: _idCtrl,
                  decoration: const InputDecoration(
                    labelText: "ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Rechercher"),
                ),
                const SizedBox(height: 20),
                if (_results.isNotEmpty)
                  ResultList(items: _results, globMap: _globMap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 2. RECHERCHE PAR TITRE
// ============================================================

class SearchTitre extends StatefulWidget {
  const SearchTitre({super.key});

  @override
  State<SearchTitre> createState() => _SearchTitreState();
}

class _SearchTitreState extends State<SearchTitre> {
  final _titreCtrl = TextEditingController();
  final _service = EvenementService();
  final _globService = GlobalInfoService();

  List<EvenementModel> _results = [];
  Map<int, GlobalInfo> _globMap = {};

  Future<void> _search() async {
    final list = await _service.searchEvenementsByTitre(_titreCtrl.text.trim());

    _globMap.clear();
    for (var e in list) {
      final info = await _globService.getById(e.globId!);
      _globMap[e.globId!] = info!;
    }

    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche par titre")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: _titreCtrl,
                  decoration: const InputDecoration(
                    labelText: "Titre",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Rechercher"),
                ),
                const SizedBox(height: 20),
                if (_results.isNotEmpty)
                  ResultList(items: _results, globMap: _globMap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 3. RECHERCHE PAR CATÉGORIE
// ============================================================

class SearchCategorie extends StatefulWidget {
  const SearchCategorie({super.key});

  @override
  State<SearchCategorie> createState() => _SearchCategorieState();
}

class _SearchCategorieState extends State<SearchCategorie> {
  final _service = EvenementService();
  final _globService = GlobalInfoService();

  int? _selectedCat;

  List<EvenementModel> _results = [];
  Map<int, GlobalInfo> _globMap = {};

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

  Future<void> _search() async {
    if (_selectedCat == null) return;

    final list = await _service.searchEvenementsByCategorie(_selectedCat!);

    _globMap.clear();
    for (var e in list) {
      final info = await _globService.getById(e.globId!);
      _globMap[e.globId!] = info!;
    }

    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche par catégorie")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedCat,
                  items: List.generate(
                    _categories.length,
                    (i) =>
                        DropdownMenuItem(value: i, child: Text(_categories[i])),
                  ),
                  onChanged: (v) => setState(() => _selectedCat = v),
                  decoration: const InputDecoration(
                    labelText: "Catégorie",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Rechercher"),
                ),
                const SizedBox(height: 20),
                if (_results.isNotEmpty)
                  ResultList(items: _results, globMap: _globMap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 4. RECHERCHE PAR MOTS‑CLÉS
// ============================================================

class SearchMotsCles extends StatefulWidget {
  const SearchMotsCles({super.key});

  @override
  State<SearchMotsCles> createState() => _SearchMotsClesState();
}

class _SearchMotsClesState extends State<SearchMotsCles> {
  final _mc1Ctrl = TextEditingController();
  final _mc2Ctrl = TextEditingController();
  final _mc3Ctrl = TextEditingController();

  bool _modeEt = false;

  final _service = EvenementService();
  final _globService = GlobalInfoService();

  List<EvenementModel> _results = [];
  Map<int, GlobalInfo> _globMap = {};

  Future<void> _search() async {
    final mc1 = _mc1Ctrl.text.trim();
    final mc2 = _mc2Ctrl.text.trim();
    final mc3 = _mc3Ctrl.text.trim();

    if (mc1.isEmpty) return;

    final list = await _service.searchEvenementsByKeywordsEtOu(
      mc1,
      mc2,
      mc3,
      _modeEt,
    );

    _globMap.clear();
    for (var e in list) {
      final info = await _globService.getById(e.globId!);
      _globMap[e.globId!] = info!;
    }

    setState(() => _results = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche par mots‑clés")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                TextField(
                  controller: _mc1Ctrl,
                  decoration: const InputDecoration(
                    labelText: "Mot‑clé 1 (obligatoire)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mc2Ctrl,
                  decoration: const InputDecoration(
                    labelText: "Mot‑clé 2",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _mc3Ctrl,
                  decoration: const InputDecoration(
                    labelText: "Mot‑clé 3",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _modeEt,
                      onChanged: (v) => setState(() => _modeEt = v!),
                    ),
                    const Text("Mode ET"),
                    Radio<bool>(
                      value: false,
                      groupValue: _modeEt,
                      onChanged: (v) => setState(() => _modeEt = v!),
                    ),
                    const Text("Mode OU"),
                  ],
                ),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text("Rechercher"),
                ),
                const SizedBox(height: 20),

                if (_results.isNotEmpty)
                  ResultList(items: _results, globMap: _globMap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
