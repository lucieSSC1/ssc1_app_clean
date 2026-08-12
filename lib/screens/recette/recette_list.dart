// ssc1_app/lib/screens/recette/recette_list.dart
//
// Liste : Recettes (module Loisir - SSC1)
// ---------------------------------------
// Affiche toutes les recettes.
//
// Actions :
// - Ouvrir le détail
// - Ajouter une recette

import 'package:flutter/material.dart';

import '../../models/recette_model.dart';
import '../../services/recette_service.dart';

import 'recette_detail.dart';
import 'recette_form.dart';

class RecetteList extends StatefulWidget {
  const RecetteList({super.key});

  @override
  State<RecetteList> createState() => _RecetteListState();
}

class _RecetteListState extends State<RecetteList> {
  final _service = RecetteService();

  List<Recette> _liste = [];
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
      debugPrint("Erreur chargement recettes : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recettes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvelle recette",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RecetteForm(),
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
              ? const Center(child: Text("Aucune recette"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final r = _liste[index];

                    return ListTile(
                      title: Text(r.nom ?? "(Sans nom)"),
                      subtitle: Text(r.categorie ?? "—"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecetteDetail(recette: r),
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