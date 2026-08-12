/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/projet/projet_screen.dart
   ÉCRAN : Projet (Structure 4)

   BOUTONS :
     - Définition
     - Journal
     - Rapport L–T–A
     - Statistiques multiprojet

   BAS DE L’ÉCRAN :
     - Statistiques du projet actif :
         heures travaillées
         heures planifiées
         % complétion
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../lot/lot_list_screen.dart';
import '../projet/journal_projet_screen.dart';
import '../statistiques/statistiques_multiprojet_screen.dart';

import '../../reports/rapport_lot_tache_activite_pdf.dart';
import '../../utils/pdf_saver.dart';

import '../../api/lot_api.dart';
import '../../api/tache_api.dart';
import '../../api/activite_api.dart';
import '../../api/journee_api.dart';

class ProjetScreen extends StatefulWidget {
  final int projetId;
  final String nomProjet;

  const ProjetScreen({
    super.key,
    required this.projetId,
    required this.nomProjet,
  });

  @override
  State<ProjetScreen> createState() => _ProjetScreenState();
}

class _ProjetScreenState extends State<ProjetScreen> {
  bool loading = false;

  double heuresTravaillees = 0;
  double heuresPlanifiees = 0;

  @override
  void initState() {
    super.initState();
    chargerStatistiquesProjet();
  }

  Future<void> chargerStatistiquesProjet() async {
    final lots = await LotApi.getLotsParProjet(widget.projetId);

    double totalTrav = 0;
    double totalPlan = 0;

    for (final lot in lots) {
      final taches = await TacheApi.getTachesParLot(lot.id);

      for (final t in taches) {
        final activites = await ActiviteApi.getActivitesParTache(t.id);

        for (final a in activites) {
          final journees = await JourneeApi.getJourneesParActivite(a.id);

          totalTrav += journees.fold(
            0.0,
            (sum, j) => sum + j.heuresTravaillees,
          );

          totalPlan += (a.duree ?? 0);
        }
      }
    }

    setState(() {
      heuresTravaillees = totalTrav;
      heuresPlanifiees = totalPlan;
    });
  }

  Future<void> genererRapportLotTacheActivite() async {
    setState(() => loading = true);

    final lots = await LotApi.getLotsParProjet(widget.projetId);

    Map<int, List<TacheModel>> tachesParLot = {};
    Map<int, List<ActiviteModel>> activitesParTache = {};
    Map<int, List<JourneeModel>> journeesParActivite = {};

    for (final lot in lots) {
      final taches = await TacheApi.getTachesParLot(lot.id);
      tachesParLot[lot.id] = taches;

      for (final t in taches) {
        final activites = await ActiviteApi.getActivitesParTache(t.id);
        activitesParTache[t.id] = activites;

        for (final a in activites) {
          final journees = await JourneeApi.getJourneesParActivite(a.id);
          journeesParActivite[a.id] = journees;
        }
      }
    }

    final pdfBytes = await generateRapportLotTacheActivitePdf(
      projetId: widget.projetId,
      nomProjet: widget.nomProjet,
      lots: lots,
      tachesParLot: tachesParLot,
      activitesParTache: activitesParTache,
      journeesParActivite: journeesParActivite,
    );

    await saveAndOpenPdf(
      bytes: pdfBytes,
      filename: "rapport_structure_projet_${widget.projetId}.pdf",
    );

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final completion = heuresPlanifiees == 0
        ? 0
        : (heuresTravaillees / heuresPlanifiees) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text("Projet #${widget.projetId} — ${widget.nomProjet}"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------------------------------------------------
            // BOUTONS PRINCIPAUX
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LotListScreen(projetId: widget.projetId),
                      ),
                    );
                  },
                  child: const Text("Définition"),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JournalProjetScreen(
                          projetId: widget.projetId,
                          nomProjet: widget.nomProjet,
                        ),
                      ),
                    );
                  },
                  child: const Text("Journal"),
                ),

                ElevatedButton(
                  onPressed: loading ? null : genererRapportLotTacheActivite,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Rapport L–T–A"),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatistiquesMultiprojetScreen(),
                      ),
                    );
                  },
                  child: const Text("Statistiques"),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ---------------------------------------------------------
            // STATISTIQUES DU PROJET ACTIF
            // ---------------------------------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Statistiques du projet",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text("Heures travaillées : ${heuresTravaillees.toStringAsFixed(1)} h"),
                  Text("Heures planifiées : ${heuresPlanifiees.toStringAsFixed(1)} h"),
                  Text("Complétion : ${completion.toStringAsFixed(1)} %"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}