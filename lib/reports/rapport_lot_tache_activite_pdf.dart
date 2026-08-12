/* ---------------------------------------------------------------------------
   CHEMIN : lib/reports/rapport_lot_tache_activite_pdf.dart
   RAPPORT PDF : LOT ? TÂCHE ? ACTIVITÉ (Structure 4)

   RÈGLES :
     - heures_travaillées AVANT heures_planifiées
     - heures_planifiées = valeur unique par activité
     - heures_travaillées = somme des journées de l’activité

   STRUCTURE :
     LOT :
       - id, code, nom
       - heures_travaillées
       - heures_planifiées (somme des activités du lot)

     TÂCHE :
       - id, code, nom
       - heures_travaillées
       - heures_planifiées (somme des activités de la tâche)

     ACTIVITÉ :
       - id, code, nom
       - heures_travaillées
       - heures_planifiées (valeur unique)

   PIED DE PAGE :
     - date actuelle à gauche
     - page X de Y à droite
   --------------------------------------------------------------------------- */

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/lot_model.dart';
import '../models/tache_model.dart';
import '../models/activite_model.dart';
import '../models/journee_model.dart';

String dateActuelle() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}

Future<Uint8List> generateRapportLotTacheActivitePdf({
  required int projetId,
  required String nomProjet,
  required List<LotModel> lots,
  required Map<int, List<TacheModel>> tachesParLot,
  required Map<int, List<ActiviteModel>> activitesParTache,
  required Map<int, List<JourneeModel>> journeesParActivite,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(24),

      // ---------------------------------------------------------
      // PIED DE PAGE
      // ---------------------------------------------------------
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(dateActuelle(), style: const pw.TextStyle(fontSize: 10)),
          pw.Text(
            "page ${context.pageNumber} de ${context.pagesCount}",
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),

      // ---------------------------------------------------------
      // CONTENU
      // ---------------------------------------------------------
      build: (context) => [
        // EN-TÊTE
        pw.Text(
          "Rapport LOT – TÂCHE – ACTIVITÉ",
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),

        pw.Text(
          "Projet #$projetId — $nomProjet",
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),

        // ---------------------------------------------------------
        // LOTS
        // ---------------------------------------------------------
        ...lots.map((lot) {
          final taches = tachesParLot[lot.id] ?? [];

          // Calcul LOT
          double heuresTravLot = 0;
          double heuresPlanLot = 0;

          for (final t in taches) {
            final activites = activitesParTache[t.id] ?? [];

            for (final a in activites) {
              final journees = journeesParActivite[a.id] ?? [];

              final heuresTravAct =
                  journees.fold(0.0, (sum, j) => sum + j.heuresTravaillees);

              heuresTravLot += heuresTravAct;
              heuresPlanLot += (a.duree ?? 0);
            }
          }

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                color: PdfColors.blue100,
                child: pw.Text(
                  "LOT ${lot.code} — ${lot.nom}",
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4, bottom: 12),
                child: pw.Text(
                  "Heures travaillées : ${heuresTravLot.toStringAsFixed(1)} h\n"
                  "Heures planifiées : ${heuresPlanLot.toStringAsFixed(1)} h",
                ),
              ),

              // -----------------------------------------------------
              // TÂCHES DU LOT
              // -----------------------------------------------------
              ...taches.map((t) {
                final activites = activitesParTache[t.id] ?? [];

                // Calcul TÂCHE
                double heuresTravTache = 0;
                double heuresPlanTache = 0;

                for (final a in activites) {
                  final journees = journeesParActivite[a.id] ?? [];

                  final heuresTravAct =
                      journees.fold(0.0, (sum, j) => sum + j.heuresTravaillees);

                  heuresTravTache += heuresTravAct;
                  heuresPlanTache += (a.duree ?? 0);
                }

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(6),
                      color: PdfColors.grey200,
                      child: pw.Text(
                        "TÂCHE ${t.code} — ${t.nom}",
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4, bottom: 8),
                      child: pw.Text(
                        "Heures travaillées : ${heuresTravTache.toStringAsFixed(1)} h\n"
                        "Heures planifiées : ${heuresPlanTache.toStringAsFixed(1)} h",
                      ),
                    ),

                    // -------------------------------------------------
                    // ACTIVITÉS DE LA TÂCHE
                    // -------------------------------------------------
                    ...activites.map((a) {
                      final journees = journeesParActivite[a.id] ?? [];

                      final heuresTravAct = journees.fold(
                        0.0,
                        (sum, j) => sum + j.heuresTravaillees,
                      );

                      final heuresPlanAct = a.duree ?? 0;

                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 12, bottom: 10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "ACTIVITÉ ${a.code} — ${a.nom}",
                              style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              "Heures travaillées : ${heuresTravAct.toStringAsFixed(1)} h\n"
                              "Heures planifiées : ${heuresPlanAct.toStringAsFixed(1)} h",
                              style: const pw.TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),

              pw.SizedBox(height: 20),
            ],
          );
        }).toList(),
      ],
    ),
  );

  return pdf.save();
}