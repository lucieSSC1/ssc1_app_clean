// ssc1_app/lib/screens/biographie/acquisition_list.dart
//
// Écran : Liste des acquisitions (version SSC1)
// ---------------------------------------------
// - Affiche toutes les acquisitions
// - Permet d’ouvrir le détail
// - Permet de créer une nouvelle acquisition
//
// Ce fichier n’existait pas dans structure 2 : il complète le module
// Acquisition dans la structure 4.

import 'package:flutter/material.dart';

import '../../models/acquisition_model.dart';
import '../../services/acquisition_service.dart';

import 'acquisition_detail.dart';
import 'acquisition_form.dart';

class AcquisitionList extends StatefulWidget {
  const AcquisitionList({super.key});

  @override
  State<AcquisitionList> createState() => _AcquisitionListState();
}

class _AcquisitionListState extends State<AcquisitionList> {
  final _service = AcquisitionService();

  List<Acquisition> _liste = [];
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
      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement acquisitions : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acquisitions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouvelle acquisition",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AcquisitionForm(),
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
              ? const Center(child: Text("Aucune acquisition"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final a = _liste[index];

                    return ListTile(
                      title: Text(a.nom),
                      subtitle: Text(
                        a.prix != null ? "${a.prix} \$" : "Sans prix",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AcquisitionDetail(acquisition: a),
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