// ssc1_app/lib/screens/emploi/emploi_list.dart
//
// Liste : Emplois (version SSC1)
// ------------------------------
// Affiche tous les emplois.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un emploi
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/emploi_model.dart';
import '../../services/emploi_service.dart';

import 'emploi_detail.dart';
import 'emploi_form.dart';

class EmploiList extends StatefulWidget {
  const EmploiList({super.key});

  @override
  State<EmploiList> createState() => _EmploiListState();
}

class _EmploiListState extends State<EmploiList> {
  final _service = EmploiService();

  List<Emploi> _liste = [];
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

      // Tri alphabétique par fonction
      data.sort((a, b) {
        final f1 = a.fonction?.toLowerCase() ?? "";
        final f2 = b.fonction?.toLowerCase() ?? "";
        return f1.compareTo(f2);
      });

      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement emplois : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emplois"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvel emploi",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmploiForm(),
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
              ? const Center(child: Text("Aucun emploi"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final e = _liste[index];

                    return ListTile(
                      title: Text(e.fonction ?? "(Sans fonction)"),
                      subtitle: Text(
                        [
                          if (e.noContrat != null && e.noContrat!.isNotEmpty)
                            "Contrat : ${e.noContrat}",
                          if (e.tauxHoraire != null)
                            "Taux : ${e.tauxHoraire} \$ / h",
                        ].join(" • "),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmploiDetail(emploi: e),
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