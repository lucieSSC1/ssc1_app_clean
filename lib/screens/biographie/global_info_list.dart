// ssc1_app/lib/screens/biographie/global_info_list.dart
//
// Écran : Liste des GlobalInfo
// -----------------------------
// Affiche toutes les GlobalInfo disponibles.
// Permet :
// - d’ouvrir le détail (global_info_detail.dart)
// - de créer une nouvelle GlobalInfo (global_info_form.dart)
//
// Ce fichier n’existait pas dans structure 2, mais il est essentiel
// dans SSC1 pour compléter le module GlobalInfo.

import 'package:flutter/material.dart';

import '../../models/global_info_model.dart';
import '../../services/global_info_service.dart';

import 'global_info_detail.dart';
import 'global_info_form.dart';

class GlobalInfoList extends StatefulWidget {
  const GlobalInfoList({super.key});

  @override
  State<GlobalInfoList> createState() => _GlobalInfoListState();
}

class _GlobalInfoListState extends State<GlobalInfoList> {
  final _service = GlobalInfoService();

  List<GlobalInfo> _liste = [];
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
      final data = await _service.getAll(); // À ajouter dans le service
      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement GlobalInfo : $e");
    }
  }

  // ------------------------------------------------------------
  // Format date
  // ------------------------------------------------------------
  String _formatDate(DateTime? d) {
    if (d == null) return "—";
    return "${d.day.toString().padLeft(2, '0')}-"
           "${d.month.toString().padLeft(2, '0')}-"
           "${d.year}";
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des GlobalInfo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Créer",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GlobalInfoForm()),
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
              ? const Center(child: Text("Aucune GlobalInfo"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final info = _liste[index];

                    return ListTile(
                      title: Text(info.type),
                      subtitle: Text(
                        "Début : ${_formatDate(info.debut)}\n"
                        "Fin : ${_formatDate(info.fin)}",
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GlobalInfoDetail(info: info),
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