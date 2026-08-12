/* ---------------------------------------------------------------------------
   CHEMIN : lib/reports/journal_projet_pdf.dart
   RAPPORT PDF : Journal du projet (Structure 4)

   - En-tête : proj_id, nomProjet, total heures
   - Corps : date, heures, objectif, description, suivi
   - Pied de page : date actuelle + page X de Y
   --------------------------------------------------------------------------- */

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/journee_model.dart';
import '../utils/pdf_saver.dart';   // fonction saveAndOpenPdf()

String dateActuelle() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}

Future<Uint8List> generateJournalProjetPdf({
  required int projetId,
  required String nomProjet,
  required double totalHeures,
  required List<JourneeModel> journees,
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
          pw.Text(dateActuelle(),
              style: const pw.TextStyle(fontSize: 10)),
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
          "Projet #$projetId — $nomProjet",
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          "Total heures travaillées : ${totalHeures.toStringAsFixed(1)} h",
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),

        // JOURNÉES
        ...journees.map((j) {
          return pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "${j.date} — ${j.heuresTravaillees.toStringAsFixed(1)} h",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),

                if ((j.objectif ?? "").isNotEmpty)
                  pw.Text("Objectif : ${j.objectif}"),

                if ((j.description ?? "").isNotEmpty)
                  pw.Text("Description : ${j.description}"),

                if ((j.suite ?? "").isNotEmpty)
                  pw.Text("Suivi : ${j.suite}"),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );

  return pdf.save();
}