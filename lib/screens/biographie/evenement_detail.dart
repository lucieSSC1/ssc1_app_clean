// ============================================================
// FICHIER : lib/screens/biographie/evenement_detail.dart
// Version SSC1 — Fiche officielle + Modifier + Supprimer + Flèches
// ============================================================

import 'package:flutter/material.dart';

import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../services/event_categ_service.dart';
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

    // ⭐ Correction : recharger l’événement depuis Supabase
    final idToLoad = _evt?.id ?? widget.liste[_pos].id!;
    _evt = await _evtService.getEvenementById(idToLoad);

    // ⭐ AJOUT PRINT : vérifier que glob_info est rechargé
    if (_evt!.globId != null) {
      print("DEBUG-GLOB: getById(${_evt!.globId})  >>>>>> _charger()");
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

  void _first() {
    if (_pos > 0) {
      _pos = 0;
      _charger();
    }
  }

  void _prev() {
    if (_pos > 0) {
      _pos--;
      _charger();
    }
  }

  void _next() {
    if (_pos < widget.liste.length - 1) {
      _pos++;
      _charger();
    }
  }

  void _last() {
    if (_pos < widget.liste.length - 1) {
      _pos = widget.liste.length - 1;
      _charger();
    }
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
        title: Text("Evenement (${_pos + 1}/${widget.liste.length})"),
        actions: [
          if (ficheOfficielle)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Modifier",
              onPressed: () async {
                final updated = await showDialog<bool>(
                  context: context,
                  builder: (_) => Dialog(
                    child: SizedBox(width: 420, child: EvenementForm(evt: evt)),
                  ),
                );

                if (updated == true) {
                  // ⭐⭐ Recharge complet après sauvegarde

                  // 1. Recharger l'événement
                  final freshEvt = await _evtService.getEvenementById(
                    _evt!.id!,
                  );
                  _evt = freshEvt;

                  // 2. Recharger glob_info
                  if (_evt!.globId != null) {
                    print(
                      "DEBUG-GLOB: getById(${_evt!.globId})  >>>>>> bouton Modifier",
                    );
                    _info = await _globService.getById(_evt!.globId!);
                  }

                  // 3. Recharger les catégories
                  final cats = await _catService.getAll();
                  _catMap = {for (var c in cats) c.id: c.nom};

                  // 4. Rafraîchir l'affichage
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
                  builder: (_) => AlertDialog(
                    title: const Text("Supprimer"),
                    content: Text("Supprimer ${evt.nom} ?"),
                    actions: [
                      TextButton(
                        child: const Text("Annuler"),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      ElevatedButton(
                        child: const Text("Supprimer"),
                        onPressed: () => Navigator.pop(context, true),
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
                      "Critere : ${widget.critere}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                _ligne("ID", "${evt.id}"),
                _ligne("Debut", _fmt(info?.debut)),
                _ligne("Fin", _fmt(info?.fin)),
                _ligne("Type", info?.type ?? "-"),
                _ligne("Categorie", catNom),
                _ligne("Nom", evt.nom),
                _ligne("Mot cle 1", evt.motCle1 ?? ""),
                _ligne("Mot cle 2", evt.motCle2 ?? ""),
                _ligne("Mot cle 3", evt.motCle3 ?? ""),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 120,
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

                const SizedBox(height: 20),

                if (widget.liste.length > 1)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: _pos > 0 ? _first : null,
                          child: const Text(
                            "<<",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: _pos > 0 ? _prev : null,
                          child: const Text(
                            "<-",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          "${_pos + 1}/${widget.liste.length}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: _pos < widget.liste.length - 1
                              ? _next
                              : null,
                          child: const Text(
                            "->",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: _pos < widget.liste.length - 1
                              ? _last
                              : null,
                          child: const Text(
                            ">>",
                            style: TextStyle(fontSize: 18),
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
