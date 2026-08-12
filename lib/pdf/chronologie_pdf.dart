// Fichier : lib/pdf/chronologie_pdf.dart

import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ChronologiePdf {
  static Future<Uint8List> generate(List<dynamic> data, String titre) async {
    final pdf = pw.Document();

    final dateFormat = DateFormat("dd-MM-yyyy");

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            titre,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),

          // Tableau
          pw.Table(
            border: pw.TableBorder.all(width: 0.5),
            columnWidths: {
              0: pw.FixedColumnWidth(80),
              1: pw.FixedColumnWidth(80),
              2: pw.FixedColumnWidth(50),
              3: pw.FlexColumnWidth(),
            },
            children: [
              // En-tête
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Début"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Fin"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Type"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Text("Nom"),
                  ),
                ],
              ),

              // Lignes
              ...data.map((e) {
                return pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(dateFormat.format(DateTime.parse(e["debut"]))),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(dateFormat.format(DateTime.parse(e["fin"]))),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(e["type"]),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(4),
                      child: pw.Text(e["nom"]),
                    ),
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
}
