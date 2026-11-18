// ============================================================
// FICHIER : lib/pdf/chronologie_pdf.dart
// SSC1 - Générateur de chronologie
// ============================================================

import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/chronologie_item.dart';

class ChronologiePdf {
  static Future<Uint8List> generate({
    required List<ChronologieItem> items,
    required DateTime debut,
    required DateTime fin,
    required List<String> types,
  }) async {
    final pdf = pw.Document();

    final roboto = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Regular.ttf'),
    );

    final robotoBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Roboto-Bold.ttf'),
    );

    String fmt(DateTime? d) {
      if (d == null) return '';

      return '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),

        build: (context) => [
          pw.Text(
            'CHRONOLOGIE SSC1',
            style: pw.TextStyle(
              font: robotoBold,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Text(
            'Période : ${fmt(debut)} à ${fmt(fin)}',
            style: pw.TextStyle(font: robotoBold, fontSize: 11),
          ),

          pw.SizedBox(height: 4),

          pw.Text(
            'Types : ${types.join(", ")}',
            style: pw.TextStyle(font: robotoBold, fontSize: 11),
          ),

          pw.SizedBox(height: 20),

          pw.Table(
            border: null,

            columnWidths: {
              0: const pw.FixedColumnWidth(80), // Début
              1: const pw.FixedColumnWidth(80), // Fin
              2: const pw.FixedColumnWidth(45), // Type
              3: const pw.FlexColumnWidth(), // Description
            },

            children: [
              pw.TableRow(
                children: [
                  _header('Début', robotoBold),
                  _header('Fin', robotoBold),
                  _header('Type', robotoBold),
                  _header('Description', robotoBold),
                ],
              ),

              ...items.map(
                (item) => pw.TableRow(
                  children: [
                    _cell(fmt(item.debut), roboto),

                    _cell(fmt(item.fin), roboto),

                    _cell(item.type, roboto),

                    _cell(item.description, roboto),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _header(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: font,
          fontSize: 11,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _cell(String text, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9)),
    );
  }
}
