// ssc1_app/lib/screens/demarche/demarche_list.dart
//
// Liste : Démarches (version SSC1, sans accents)
// ---------------------------------------------
// Affiche toutes les démarches.
//
// Actions :
// - Ouvrir le détail
// - Ajouter une démarche
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/demarche_model.dart';
import '../../services/demarche_service.dart';

import 'demarche_detail.dart';
import 'demarche_form.dart';

class DemarcheList extends StatefulWidget {
  const DemarcheList({super.key});

  @override
  State<DemarcheList> createState() => _DemarcheListState();
}

class _DemarcheListState extends State<DemarcheList> {
  final _service = DemarcheService();

  List<Demarche> _liste = [];
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

      // Tri par date décroissante
      data.sort((a, b) {
        final d1 = a.date ?? DateTime(1900);
        final d2 = b.date ?? DateTime(1900);
        return d2.compareTo(d1);
      });

      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement démarches : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Démarches"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvelle démarche",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DemarcheForm(),
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
              ? const Center(child: Text("Aucune démarche"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final d = _liste[index];

                    final dateStr = d.date != null
                        ? d.date!.toIso8601String().split("T").first
                        : "Sans date";

                    return ListTile(
                      title: Text(d.service ?? "(Sans service)"),
                      subtitle: Text("$dateStr • ${d.domaine ?? '—'}"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DemarcheDetail(demarche: d),
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