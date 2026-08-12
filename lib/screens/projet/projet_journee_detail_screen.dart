// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/projet_journee_detail_screen.dart
// -----------------------------------------------------------------------------
// Zone : Détail du travail effectué (Structure 2)
// Rapport des journées du projet (lecture seule, sans note)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../api/journee_api.dart';
import '../../models/journee_model.dart';

class ProjetJourneeDetailScreen extends StatefulWidget {
  final int projetId;
  final String projetNom;

  const ProjetJourneeDetailScreen({
    super.key,
    required this.projetId,
    required this.projetNom,
  });

  @override
  State<ProjetJourneeDetailScreen> createState() =>
      _ProjetJourneeDetailScreenState();
}

class _ProjetJourneeDetailScreenState
    extends State<ProjetJourneeDetailScreen> {
  List<JourneeModel> _items = [];
  bool _chargement = true;
  String? _erreur;

  double _totalHeures = 0;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ---------------------------------------------------------------------------
  // CHARGER LE RAPPORT
  // ---------------------------------------------------------------------------
  Future<void> _charger() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      final data =
          await JourneeApi.getJourneesParProjet(widget.projetId);

      // Tri du plus récent au plus ancien
      data.sort((a, b) => b.id.compareTo(a.id));

      // Calcul du total
      double total = 0;
      for (var j in data) {
        total += j.heures;
      }

      setState(() {
        _items = data;
        _totalHeures = total;
      });
    } catch (e) {
      setState(() {
        _erreur = "Erreur lors du chargement du détail.";
      });
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Travail effectué — ${widget.projetNom}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_chargement) const LinearProgressIndicator(),

            if (_erreur != null)
              Text(
                _erreur!,
                style: const TextStyle(color: Colors.red),
              ),

            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final j = _items[index];

                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${j.date} — ${j.heures} h",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),

                          const SizedBox(height: 6),

                          if (j.objectif != null &&
                              j.objectif!.trim().isNotEmpty)
                            Text("Objectif : ${j.objectif!}"),

                          if (j.tache != null && j.tache!.trim().isNotEmpty)
                            Text("Tâche : ${j.tache!}"),

                          if (j.suite != null && j.suite!.trim().isNotEmpty)
                            Text("Suite : ${j.suite!}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // TOTAL DES HEURES
            Text(
              "Total des heures : ${_totalHeures.toStringAsFixed(1)} h",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
