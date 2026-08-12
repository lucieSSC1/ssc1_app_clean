/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/projet/projet_rapport_lta_screen.dart
   STRUCTURE 4 — Rapport LOT ? TÂCHE ? ACTIVITÉ

   Affiche :
     - Liste des LOTS du projet
     - Sous chaque LOT : liste des TÂCHES
     - Sous chaque TÂCHE : liste des ACTIVITÉS
     - Heures planifiées et travaillées

   Appelé depuis :
     projet_screen.dart ? bouton "Rapport L–T–A"
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/lot_api.dart';
import '../../api/tache_api.dart';
import '../../api/activite_api.dart';

import '../../models/lot_model.dart';
import '../../models/tache_model.dart';
import '../../models/activite_model.dart';

class ProjetRapportLTAScreen extends StatefulWidget {
  final int projetId;
  final String projetNom;

  const ProjetRapportLTAScreen({
    super.key,
    required this.projetId,
    required this.projetNom,
  });

  @override
  State<ProjetRapportLTAScreen> createState() => _ProjetRapportLTAScreenState();
}

class _ProjetRapportLTAScreenState extends State<ProjetRapportLTAScreen> {
  bool loading = true;

  List<LotModel> lots = [];
  Map<int, List<TacheModel>> taches = {};
  Map<int, List<ActiviteModel>> activites = {};

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    setState(() => loading = true);

    // -------------------------------------------------------------
    // LOTS
    // -------------------------------------------------------------
    lots = await LotApi.getLotsParProjet(widget.projetId);

    // -------------------------------------------------------------
    // TÂCHES PAR LOT
    // -------------------------------------------------------------
    for (final lot in lots) {
      taches[lot.id] = await TacheApi.getTachesParLot(lot.id);
    }

    // -------------------------------------------------------------
    // ACTIVITÉS PAR TÂCHE
    // -------------------------------------------------------------
    for (final entry in taches.entries) {
      for (final t in entry.value) {
        activites[t.id] = await ActiviteApi.getActivitesParTache(t.id);
      }
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rapport L–T–A — ${widget.projetNom}"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                for (final lot in lots) ...[
                  // ---------------------------------------------------------
                  // LOT
                  // ---------------------------------------------------------
                  Card(
                    color: Colors.blue.shade50,
                    child: ListTile(
                      title: Text(
                        "LOT ${lot.code} — ${lot.nom}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // ---------------------------------------------------------
                  // TÂCHES DU LOT
                  // ---------------------------------------------------------
                  for (final t in taches[lot.id] ?? []) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Card(
                        color: Colors.green.shade50,
                        child: ListTile(
                          title: Text(
                            "Tâche ${t.code} — ${t.nom}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Heures planifiées : ${t.heuresPlanifiees}",
                          ),
                        ),
                      ),
                    ),

                    // -----------------------------------------------------
                    // ACTIVITÉS DE LA TÂCHE
                    // -----------------------------------------------------
                    for (final a in activites[t.id] ?? []) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Card(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            title: Text("${a.code} — ${a.nom}"),
                            subtitle: Text(
                              "Planifiées : ${a.heuresPlanifiees} h   |   Travaillées : ${a.heuresTravaillees} h",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 20),
                ],
              ],
            ),
    );
  }
}
