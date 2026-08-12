// ssc1_app/lib/screens/biographie/reference_list.dart
//
// Écran : Liste des références documentaires (version SSC1)
// ---------------------------------------------------------
// Affiche toutes les références (livres, DVD, audio, vidéo,
// articles, documents, etc.).
//
// Actions :
// - Ouvrir le détail
// - Ajouter une nouvelle référence
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/reference_model.dart';
import '../../services/reference_service.dart';

import 'reference_detail.dart';
import 'reference_form.dart';

class ReferenceList extends StatefulWidget {
  const ReferenceList({super.key});

  @override
  State<ReferenceList> createState() => _ReferenceListState();
}

class _ReferenceListState extends State<ReferenceList> {
  final _service = ReferenceService();

  List<Reference> _liste = [];
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

      // Tri par titre
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
      debugPrint("Erreur chargement références : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Références"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvelle référence",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReferenceForm(),
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
              ? const Center(child: Text("Aucune référence"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final r = _liste[index];

                    return ListTile(
                      title: Text(r.titre ?? "(Sans titre)"),
                      subtitle: Text(
                        [
                          if (r.type != null && r.type!.isNotEmpty) r.type,
                          if (r.auteur != null && r.auteur!.isNotEmpty) r.auteur,
                        ].join(" • "),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReferenceDetail(reference: r),
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