// ssc1_app/lib/screens/prospect/prospect_list.dart
//
// Liste : Prospects (version SSC1)
// --------------------------------
// Affiche tous les prospects.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un prospect
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import '../../models/prospect_model.dart';
import '../../services/prospect_service.dart';

import 'prospect_detail.dart';
import 'prospect_form.dart';

class ProspectList extends StatefulWidget {
  const ProspectList({super.key});

  @override
  State<ProspectList> createState() => _ProspectListState();
}

class _ProspectListState extends State<ProspectList> {
  final _service = ProspectService();

  List<Prospect> _liste = [];
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
      debugPrint("Erreur chargement prospects : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prospects"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouveau prospect",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProspectForm(),
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
              ? const Center(child: Text("Aucun prospect"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final p = _liste[index];

                    return ListTile(
                      title: Text(p.nom ?? "(Sans nom)"),
                      subtitle: Text(p.entreprise ?? "—"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProspectDetail(prospect: p),
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