// ============================================================
// FICHIER : lib/pdf/chronologie_pdf.dart
// Générateur PDF SSC1 — Liste + Fiche
// ============================================================

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class ChronologiePdf {
  static Future<Uint8List> generate(
    List<dynamic> data,
    String titre, {
    String? critere,
  }) async {
    final pdf = pw.Document();

    // ⭐ Charger police Unicode Roboto depuis assets
    final roboto = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Regular.ttf"),
    );
    final robotoBold = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Roboto-Bold.ttf"),
    );

    final dateFormat = DateFormat("dd-MM-yyyy");

    // ⭐ Parseur dd-mm-yyyy
    DateTime _parseDDMMYYYY(String s) {
      if (s.isEmpty) return DateTime(1);
      final parts = s.split('-');
      return DateTime(
        int.parse(parts[2]), // année
        int.parse(parts[1]), // mois
        int.parse(parts[0]), // jour
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            titre,
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              font: robotoBold,
            ),
          ),

          if (critere != null) ...[
            pw.SizedBox(height: 10),
            pw.Text(
              "Critère : $critere",
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                font: robotoBold,
              ),
            ),
          ],

          pw.SizedBox(height: 20),

          pw.Table(
            border: null,
            columnWidths: {
              0: pw.FixedColumnWidth(60), // ID aligné à droite
              1: pw.FixedColumnWidth(80), // Début
              2: pw.FixedColumnWidth(80), // Fin
              3: pw.FixedColumnWidth(50), // Type
              4: pw.FlexColumnWidth(), // Nom
            },
            children: [
              pw.TableRow(
                children: [
                  _header("ID", robotoBold),
                  _header("Début", robotoBold),
                  _header("Fin", robotoBold),
                  _header("Type", robotoBold),
                  _header("Nom", robotoBold),
                ],
              ),

              ...data.map((e) {
                final debut = e["debut"] ?? "";
                final fin = e["fin"] ?? "";
                final id = e["id"];

                final idStr = id == null ? "" : id.toString().padLeft(4, ' ');

                return pw.TableRow(
                  children: [
                    _cell(idStr, roboto, alignRight: true),

                    _cell(
                      debut.isEmpty
                          ? ""
                          : dateFormat.format(_parseDDMMYYYY(debut)),
                      roboto,
                    ),

                    _cell(
                      fin.isEmpty ? "" : dateFormat.format(_parseDDMMYYYY(fin)),
                      roboto,
                    ),

                    _cell(e["type"] ?? "", roboto),
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
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: font),
      ),
    );
  }

  static pw.Widget _cell(String text, pw.Font font, {bool alignRight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Text(
        text,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
        style: pw.TextStyle(font: font),
      ),
    );
  }
}
