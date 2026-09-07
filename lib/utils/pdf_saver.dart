/* ---------------------------------------------------------------------------
   CHEMIN : lib/utils/pdf_saver.dart
   UTILITAIRE : Sauvegarde + ouverture d’un PDF sur toutes plateformes
   Version SSC1 — Chemin fixe + dossier + noms auto + pop-up simplifié
   --------------------------------------------------------------------------- */

import 'dart:io';
import 'dart:typed_data';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';

/// Dossier PDF SSC1 (Windows)
/// IMPORTANT : doit exister ou être créé automatiquement
const String pdfFolder = "C:/Users/Lucie/Documents/SSC1_PDF/";

/// Génère un nom unique : ssc1_evenement001.pdf
Future<String> _generateUniqueName(String base) async {
  final dir = Directory(pdfFolder);

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.contains(base))
      .toList();

  int maxNum = 0;

  for (var f in files) {
    final name = f.path.split("/").last;

    // Exemple : ssc1_evenement001.pdf
    final numPart = name.replaceAll(base, "").replaceAll(".pdf", "");
    final num = int.tryParse(numPart);

    if (num != null && num > maxNum) {
      maxNum = num;
    }
  }

  final next = (maxNum + 1).toString().padLeft(3, '0');
  return "$base$next.pdf";
}

/// Sauvegarde un PDF sans l’ouvrir
Future<String> savePdf({
  required Uint8List bytes,
  required String baseName, // Exemple : "ssc1_evenement"
}) async {
  final dir = Directory(pdfFolder);

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final filename = await _generateUniqueName(baseName);
  final file = File("$pdfFolder$filename");

  await file.writeAsBytes(bytes, flush: true);

  return file.path;
}

/// Ouvre un PDF existant
Future<void> openPdf(String path) async {
  await OpenFilex.open(path);
}

/// Affiche un pop-up avec chemin complet (sans nom séparé)
void showPdfPopup(BuildContext context, String path) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("PDF généré"),
      content: Text("Chemin complet :\n$path"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
