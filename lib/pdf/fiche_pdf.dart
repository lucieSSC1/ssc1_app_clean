// ============================================================
// FICHIER : lib/pdf/fiche_pdf.dart
// PDF SSC1 — Fiche événement
// ============================================================

import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class FichePdf {
  static Future<Uint8List> generate({
    required Map<String, dynamic> evt,
    required Map<String, dynamic>? glob,
    String? critere,
  }) async {
    final pdf = pw.Document();

    final roboto = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"),
    );

    final robotoBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            "FICHE ÉVÉNEMENT",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              font: robotoBold,
            ),
          ),

          pw.SizedBox(height: 15),

          _ligne("ID", "${evt["id"] ?? "-"}", roboto, robotoBold),

          _ligne("Début", glob?["debut"] ?? "-", roboto, robotoBold),

          _ligne("Fin", glob?["fin"] ?? "-", roboto, robotoBold),

          pw.SizedBox(height: 8),

          _ligne("Nom", evt["nom"] ?? "", roboto, robotoBold),

          _ligne("Type", glob?["type"] ?? "-", roboto, robotoBold),

          _ligne("Catégorie", evt["categorie"] ?? "-", roboto, robotoBold),

          pw.SizedBox(height: 8),

          _ligne("Mot clé 1", evt["motCle1"] ?? "", roboto, robotoBold),

          _ligne("Mot clé 2", evt["motCle2"] ?? "", roboto, robotoBold),

          _ligne("Mot clé 3", evt["motCle3"] ?? "", roboto, robotoBold),

          pw.SizedBox(height: 15),

          pw.Text(
            "DESCRIPTION",
            style: pw.TextStyle(
              font: robotoBold,
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            evt["description"] ?? "",
            style: pw.TextStyle(font: roboto, fontSize: 10),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _ligne(
    String libelle,
    String valeur,
    pw.Font roboto,
    pw.Font robotoBold,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 70,
            child: pw.Text(
              libelle,
              style: pw.TextStyle(
                font: robotoBold,
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              valeur,
              style: pw.TextStyle(font: roboto, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
