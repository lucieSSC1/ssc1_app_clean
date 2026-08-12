// ssc1_app/lib/screens/etudes/programme_list.dart
//
// Liste : Programmes (version SSC1)
// ---------------------------------
// Affiche tous les programmes d'études.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un programme
//
// Ce fichier était vide dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/programme_model.dart';
import '../../services/programme_service.dart';

import 'programme_detail.dart';
import 'programme_form.dart';

class ProgrammeList extends StatefulWidget {
  const ProgrammeList({super.key});

  @override
  State<ProgrammeList> createState() => _ProgrammeListState();
}

class _ProgrammeListState extends State<ProgrammeList> {
  final _service = ProgrammeService();

  List<Programme> _liste = [];
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
      debugPrint("Erreur chargement programmes : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Programmes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouveau programme",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProgrammeForm(),
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
              ? const Center(child: Text("Aucun programme"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final p = _liste[index];

                    return ListTile(
                      title: Text(p.nom ?? "(Sans nom)"),
                      subtitle: Text(
                        [
                          if (p.cout != null) "Coût : ${p.cout}",
                          if (p.etablissementId != null)
                            "Établissement #${p.etablissementId}",
                        ].join(" • "),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProgrammeDetail(programme: p),
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