// ssc1_app/lib/screens/etudes/cours_list.dart
//
// Liste : Cours (version SSC1)
// ----------------------------
// Affiche tous les cours.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un cours
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/cours_model.dart';
import '../../services/cours_service.dart';

import 'cours_detail.dart';
import 'cours_form.dart';

class CoursList extends StatefulWidget {
  const CoursList({super.key});

  @override
  State<CoursList> createState() => _CoursListState();
}

class _CoursListState extends State<CoursList> {
  final _service = CoursService();

  List<Cours> _liste = [];
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
      debugPrint("Erreur chargement cours : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cours"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouveau cours",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CoursForm(),
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
              ? const Center(child: Text("Aucun cours"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final c = _liste[index];

                    return ListTile(
                      title: Text(c.nom ?? "(Sans nom)"),
                      subtitle: Text(
                        [
                          if (c.code != null && c.code!.isNotEmpty) "Code : ${c.code}",
                          if (c.session != null && c.session!.isNotEmpty)
                            "Session : ${c.session}",
                        ].join(" • "),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CoursDetail(cours: c),
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