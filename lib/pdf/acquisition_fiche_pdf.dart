// ssc1_app/lib/pdf/acquisition_fiche_pdf.dart
//
// PDF : Fiche individuelle Acquisition (version SSC1)
// ---------------------------------------------------
// Format uniforme SSC1
// - Sans quadrillage
// - Colonnes alignées
// - Vendeur par nom
// - Maintenance complète
// - Description et commentaire compacts
// ---------------------------------------------------

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AcquisitionFichePdf {
  static Future<Uint8List> generate({
    required Map<String, dynamic> acq,
    required Map<String, dynamic>? glob,
    required List<Map<String, dynamic>> maintenances,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            "FICHE ACQUISITION",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 15),

          _ligne("ID", acq["id"]?.toString() ?? "-"),
          _ligne("Début", glob?["debut"] ?? "-"),
          _ligne("Fin", glob?["fin"] ?? "-"),
          _ligne("Type", glob?["type"] ?? "-"),

          pw.SizedBox(height: 10),

          _ligne("Nom", acq["nom"] ?? "-"),
          _ligne("Vendeur", acq["vendeur"] ?? "N/A"),
          _ligne("Prix", acq["prix"] ?? "-"),
          _ligne("Garantie", acq["garantie"] ?? "-"),
          _ligne("Expire", acq["expire"] ?? "-"),

          pw.SizedBox(height: 10),

          _ligne("Image", acq["image"] ?? "-"),
          _ligne("Facture", acq["facture"] ?? "-"),

          pw.SizedBox(height: 15),

          pw.Text(
            "DESCRIPTION",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            acq["description"] ?? "",
            style: const pw.TextStyle(fontSize: 10),
          ),

          pw.SizedBox(height: 15),

          pw.Text(
            "MAINTENANCE",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 5),

          if (maintenances.isEmpty)
            pw.Text(
              "Aucune maintenance",
              style: const pw.TextStyle(fontSize: 10),
            ),

          ...maintenances.asMap().entries.map((entry) {
            final no = entry.key + 1;
            final m = entry.value;

            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "Intervention #$no",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),

                  pw.SizedBox(height: 4),

                  _ligneMaintenance("Date", m["date"]),
                  _ligneMaintenance("À effectuer", m["aEffectuer"]),
                  _ligneMaintenance("Réparateur", m["reparateur"]),
                  _ligneMaintenance("Effectué", m["effectue"]),
                  _ligneMaintenance("Durée", m["duree"]),
                  _ligneMaintenance("Pièces", m["pieces"]),
                  _ligneMaintenance("Coût", "${m["cout"]}\$"),
                ],
              ),
            );
          }),

          pw.SizedBox(height: 15),

          pw.Text(
            "COMMENTAIRE",
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 5),

          pw.Text(
            acq["commentaire"] ?? "",
            style: const pw.TextStyle(fontSize: 10),
          ),
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
            width: 70,
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

  static pw.Widget _ligneMaintenance(String libelle, dynamic valeur) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 85,
            child: pw.Text(
              libelle,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              valeur?.toString() ?? "",
              style: const pw.TextStyle(fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}
