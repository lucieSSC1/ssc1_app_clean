// ============================================================
// FICHIER : lib/pdf/document_fiche_pdf.dart
//
// PDF : Fiche individuelle Document (version SSC1)
// ------------------------------------------------
// Format uniforme SSC1
// - Sans quadrillage
// - Colonnes alignées
// - Date saisie
// - Mots-clés
// - Chronique
// - Remarques
// ------------------------------------------------
// ============================================================

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentFichePdf {
  static Future<Uint8List> generate({
    required Map<String, dynamic> doc,
    required Map<String, dynamic>? glob,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),

        build: (context) => [
          pw.Text(
            "FICHE DOCUMENT",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 15),

          _ligne("ID", doc["id"]?.toString() ?? "-"),

          _ligne("Début", glob?["debut"] ?? "-"),

          _ligne("Fin", glob?["fin"] ?? "-"),

          _ligne("Type", glob?["type"] ?? "-"),

          pw.SizedBox(height: 10),

          _ligne("Date saisie", doc["dateSaisie"] ?? "-"),

          _ligne("Titre", doc["titre"] ?? "-"),

          _ligne("Mot clé 1", doc["motCle1"] ?? ""),

          _ligne("Mot clé 2", doc["motCle2"] ?? ""),

          _ligne("Mot clé 3", doc["motCle3"] ?? ""),

          pw.SizedBox(height: 10),

          _ligne("Chronique", doc["chroniqueUrl"] ?? "-"),

          pw.SizedBox(height: 15),

          pw.Text(
            "Remarques",
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 5),

          pw.Text(doc["rem"] ?? "", style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _ligne(String libelle, String valeur) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(
              libelle,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),

          pw.Expanded(
            child: pw.Text(valeur, style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
