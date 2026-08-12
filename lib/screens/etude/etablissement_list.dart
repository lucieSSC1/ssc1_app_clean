// ssc1_app/lib/screens/etudes/etablissement_list.dart
//
// Liste : Établissements (version SSC1)
// -------------------------------------
// Affiche tous les établissements (écoles, universités, centres de formation).
//
// Actions :
// - Ouvrir le détail
// - Ajouter un établissement
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/etablissement_model.dart';
import '../../services/etablissement_service.dart';

import 'etablissement_detail.dart';
import 'etablissement_form.dart';

class EtablissementList extends StatefulWidget {
  const EtablissementList({super.key});

  @override
  State<EtablissementList> createState() => _EtablissementListState();
}

class _EtablissementListState extends State<EtablissementList> {
  final _service = EtablissementService();

  List<Etablissement> _liste = [];
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

      // Tri alphabétique par nom
      data.sort((a, b) {
        final n1 = a.nom?.toLowerCase() ?? "";
        final n2 = b.nom?.toLowerCase() ?? "";
        return n1.compareTo(n2);
      });

      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement établissements : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Établissements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvel établissement",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EtablissementForm(),
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
              ? const Center(child: Text("Aucun établissement"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final e = _liste[index];

                    return ListTile(
                      title: Text(e.nom ?? "(Sans nom)"),
                      subtitle: Text(
                        [
                          if (e.ville != null && e.ville!.isNotEmpty) e.ville,
                          if (e.pays != null && e.pays!.isNotEmpty) e.pays,
                        ].join(" • "),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EtablissementDetail(etablissement: e),
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