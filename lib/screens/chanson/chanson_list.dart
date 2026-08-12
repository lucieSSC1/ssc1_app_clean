// ssc1_app/lib/screens/chanson/chanson_list.dart
//
// Liste : Chansons (module Loisir - SSC1)
// ---------------------------------------
// Affiche toutes les chansons.
//
// Actions :
// - Ouvrir le détail
// - Ajouter une chanson

import 'package:flutter/material.dart';

import '../../models/chanson_model.dart';
import '../../services/chanson_service.dart';

import 'chanson_detail.dart';
import 'chanson_form.dart';

class ChansonList extends StatefulWidget {
  const ChansonList({super.key});

  @override
  State<ChansonList> createState() => _ChansonListState();
}

class _ChansonListState extends State<ChansonList> {
  final _service = ChansonService();

  List<Chanson> _liste = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger la liste
  // ------------------------------------------------------------
  Future<void> _charger() async {
    setState(() => _loading = true);

    try {
      final data = await _service.getAll();

      // Tri alphabétique par titre
      data.sort((a, b) {
        final t1 = a.titre?.toLowerCase() ?? "";
        final t2 = b.titre?.toLowerCase() ?? "";
        return t1.compareTo(t2);
      });

      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement chansons : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chansons"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvelle chanson",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChansonForm(),
                ),
              );

              if (created == true) {
                _charger();
              }
            },
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _liste.isEmpty
              ? const Center(child: Text("Aucune chanson"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final c = _liste[index];

                    return ListTile(
                      title: Text(c.titre ?? "(Sans titre)"),
                      subtitle: Text(c.interprete ?? "—"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChansonDetail(chanson: c),
                          ),
                        );

                        if (updated == true) {
                          _charger();
                        }
                      },
                    );
                  },
                ),
    );
  }
}