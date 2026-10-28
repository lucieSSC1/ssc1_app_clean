/* ---------------------------------------------------------------------------
   CHEMIN : lib/utils/pdf_saver.dart
   UTILITAIRE : Sauvegarde + ouverture d’un PDF via url_launcher
   Version SSC1 — Multi‑plateforme automatique
   --------------------------------------------------------------------------- */

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

String _twoDigits(int n) => n.toString().padLeft(2, '0');

/// Nom unique : date + heure + secondes + millisecondes
String _generateTimestampName(String base) {
  final now = DateTime.now();
  final date = "${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}";
  final time =
      "${_twoDigits(now.hour)}h${_twoDigits(now.minute)}_${_twoDigits(now.second)}_${now.millisecond}";
  return "${base}_${date}_$time.pdf";
}

/// ⭐ Détermine automatiquement un dossier valide selon l’OS
Future<Directory> _getPdfDirectory() async {
  if (Platform.isWindows) {
    final user = Platform.environment["USERNAME"] ?? "User";
    final dir = Directory("C:/Users/$user/Documents/SSC1_PDF/");
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  if (Platform.isMacOS || Platform.isLinux) {
    final home = Platform.environment["HOME"] ?? "";
    final dir = Directory("$home/Documents/SSC1_PDF/");
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  if (Platform.isAndroid || Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory("${dir.path}/SSC1_PDF/");
    if (!pdfDir.existsSync()) pdfDir.createSync(recursive: true);
    return pdfDir;
  }

  // Fallback universel
  final dir = await getTemporaryDirectory();
  return dir;
}

/// ⭐ Sauvegarde seulement — NE PAS ouvrir
/// Retourne le chemin complet du fichier
Future<String> savePdf({
  required Uint8List bytes,
  required String baseName,
}) async {
  final dir = await _getPdfDirectory();
  final filename = _generateTimestampName(baseName);
  final file = File("${dir.path}/$filename");

  await file.writeAsBytes(bytes, flush: true);

  return file.path;
}

/// ⭐ Ouvre le DERNIER PDF généré dans le dossier
/// Retourne true si OK, false si aucun PDF trouvé
Future<bool> openSavedPdf() async {
  final dir = await _getPdfDirectory();

  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.toLowerCase().endsWith(".pdf"))
      .toList();

  if (files.isEmpty) return false;

  // Trouver le plus récent
  files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  final lastPdf = files.first;

  final uri = Uri.file(lastPdf.path);

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication, // ⭐ anti-cache Windows
  );

  return true;
}

/// ⭐ Fonction ancienne (générer + ouvrir) — conservée si besoin
Future<void> saveAndOpenPdf({
  required Uint8List bytes,
  required String baseName,
}) async {
  final path = await savePdf(bytes: bytes, baseName: baseName);
  final uri = Uri.file(path);

  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
