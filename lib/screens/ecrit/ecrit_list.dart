// ssc1_app/lib/screens/ecrit/ecrit_list.dart
//
// Liste : Écrits (module Loisir - SSC1)
// -------------------------------------
// Affiche tous les écrits.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un écrit

import 'package:flutter/material.dart';

import '../../models/ecrit_model.dart';
import '../../services/ecrit_service.dart';

import 'ecrit_detail.dart';
import 'ecrit_form.dart';

class EcritList extends StatefulWidget {
  const EcritList({super.key});

  @override
  State<EcritList> createState() => _EcritListState();
}

class _EcritListState extends State<EcritList> {
  final _service = EcritService();

  List<Ecrit> _liste = [];
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
      debugPrint("Erreur chargement écrits : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Écrits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvel écrit",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EcritForm(),
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
              ? const Center(child: Text("Aucun écrit"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final e = _liste[index];

                    return ListTile(
                      title: Text(e.titre ?? "(Sans titre)"),
                      subtitle: Text(e.type ?? "—"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EcritDetail(ecrit: e),
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