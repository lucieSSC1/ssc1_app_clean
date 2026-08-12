/* ---------------------------------------------------------------------------
   CHEMIN : lib/utils/pdf_saver.dart
   UTILITAIRE : Sauvegarde + ouverture d’un PDF sur toutes plateformes
   --------------------------------------------------------------------------- */

import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveAndOpenPdf({
  required Uint8List bytes,
  required String filename,
}) async {
  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/$filename");

  await file.writeAsBytes(bytes, flush: true);

  await OpenFile.open(file.path);
}
