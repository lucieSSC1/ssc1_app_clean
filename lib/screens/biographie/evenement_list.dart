// ============================================================
// FICHIER : lib/screens/biographie/evenement_list.dart
// Version compact : début → fin | type | nom
// ============================================================

import 'package:flutter/material.dart';

import '../../models/evenement_model.dart';
import '../../services/evenement_service.dart';

import 'evenement_form.dart';
import 'evenement_detail.dart';

class EvenementList extends StatefulWidget {
  const EvenementList({super.key});

  @override
  State<EvenementList> createState() => _EvenementListState();
}

class _EvenementListState extends State<EvenementList> {
  final _service = EvenementService();
  List<EvenementModel> _items = [];
  bool _loading = true;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-LIST: $msg");
    if (data != null) print("DEBUG-LIST-DATA: $data");
  }

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _debug("_charger() appelé");

    _items = await _service.getAllEvenements();

    _debug("Nombre d'événements reçus", _items.length);

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    _debug(">>> EVENEMENT_LIST CHARGÉ PAR FLUTTER <<<");
    _debug("build() → loading = $_loading");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Événements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              _debug("Bouton + → ouverture formulaire");
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EvenementForm()),
              );
              _debug("Retour formulaire, updated = $updated");
              if (updated == true) _charger();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text("Aucun événement"))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final e = _items[i];

                return ListTile(
                  title: Text(
                    "${e.debutStr()} → ${e.finStr()}   |   ${e.type ?? '—'}   |   ${e.nom}",
                  ),
                  onTap: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EvenementDetail(evt: e, liste: _items, index: i),
                      ),
                    );
                    if (updated == true) _charger();
                  },
                );
              },
            ),
    );
  }
}
