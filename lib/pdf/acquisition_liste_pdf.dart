// ssc1_app/lib/pdf/acquisition_liste_pdf.dart
//
// PDF : Liste des acquisitions (version SSC1)
// -------------------------------------------
// Format uniforme SSC1
// - Colonnes alignées
// - Sans quadrillage
// - Prix avant Nom
// - Information compacte
// -------------------------------------------

import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AcquisitionListePdf {
  static Future<Uint8List> generate(
    List<Map<String, dynamic>> data,
    String titre, {
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
            titre,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              font: robotoBold,
            ),
          ),

          if (critere != null) ...[
            pw.SizedBox(height: 10),
            pw.Text(
              "Critère : $critere",
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                font: robotoBold,
              ),
            ),
          ],

          pw.SizedBox(height: 20),

          pw.Table(
            border: null,
            columnWidths: {
              0: const pw.FixedColumnWidth(35), // ID
              1: const pw.FixedColumnWidth(10),

              2: const pw.FixedColumnWidth(70), // Début
              3: const pw.FixedColumnWidth(5),

              4: const pw.FixedColumnWidth(70), // Fin
              5: const pw.FixedColumnWidth(5),

              6: const pw.FixedColumnWidth(45), // Type
              7: const pw.FixedColumnWidth(5),

              8: const pw.FixedColumnWidth(70), // Prix
              9: const pw.FixedColumnWidth(5),

              10: const pw.FlexColumnWidth(), // Nom
            },
            children: [
              pw.TableRow(
                children: [
                  _header("ID", robotoBold),
                  pw.Text(""),

                  _header("Début", robotoBold),
                  pw.Text(""),

                  _header("Fin", robotoBold),
                  pw.Text(""),

                  _header("Type", robotoBold),
                  pw.Text(""),

                  _header("Prix", robotoBold),
                  pw.Text(""),

                  _header("Nom", robotoBold),
                ],
              ),

              ...data.map((e) {
                final id = e["id"] == null
                    ? ""
                    : e["id"].toString().padLeft(4, ' ');

                return pw.TableRow(
                  children: [
                    _cell(id, roboto, alignRight: true),
                    pw.Text(""),

                    _cell(e["debut"] ?? "", roboto),
                    pw.Text(""),

                    _cell(e["fin"] ?? "", roboto),
                    pw.Text(""),

                    _cell(e["type"] ?? "", roboto),
                    pw.Text(""),

                    _cell(e["prix"] ?? "", roboto),
                    pw.Text(""),

                    _cell(e["nom"] ?? "", roboto),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _header(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  static pw.Widget _cell(String text, pw.Font font, {bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(font: font, fontSize: 9),
      ),
    );
  }
}
