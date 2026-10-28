// lib/services/storage_service.dart
//
// Service : Supabase Storage (SSC1)
// ---------------------------------
// Buckets :
//   image
//   facture
//   chronique
//   demarche
//   recette
//   projet
//
// Gestion future :
//   - Upload fichiers
//   - Download fichiers
//   - Ouverture locale
//   - Multi-plateforme
// ---------------------------------

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final supabase = Supabase.instance.client;

  void debug(String msg) {
    print("DEBUG-STORAGE: $msg");
  }

  // ------------------------------------------------------------
  // SÉLECTION D'UN FICHIER
  // ------------------------------------------------------------
  Future<File?> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null) {
        debug("Sélection annulée");
        return null;
      }

      final path = result.files.single.path;

      if (path == null) {
        debug("Chemin fichier nul");
        return null;
      }

      debug("Fichier sélectionné : $path");

      return File(path);
    } catch (e) {
      debug("Erreur pickFile() : $e");
      return null;
    }
  }

  // ------------------------------------------------------------
  // OBTENIR EXTENSION
  // ------------------------------------------------------------
  String getExtension(File file) {
    return p.extension(file.path).replaceFirst('.', '');
  }

  // ------------------------------------------------------------
  // UPLOAD D'UN FICHIER
  // ------------------------------------------------------------
  Future<String?> uploadFile({
    required String bucket,
    required File file,
    required String fileName,
  }) async {
    try {
      debug("Upload $bucket/$fileName");

      await supabase.storage
          .from(bucket)
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      debug("Upload terminé");

      return "$bucket/$fileName";
    } catch (e) {
      debug("Erreur uploadFile() : $e");
      return null;
    }
  }

  // ------------------------------------------------------------
  // DOWNLOAD D'UN FICHIER
  // ------------------------------------------------------------
  Future<List<int>?> downloadFile({
    required String bucket,
    required String fileName,
  }) async {
    try {
      debug("Download $bucket/$fileName");

      final bytes = await supabase.storage.from(bucket).download(fileName);

      debug("Download terminé");

      return bytes;
    } catch (e) {
      debug("Erreur downloadFile() : $e");
      return null;
    }
  }

  // ------------------------------------------------------------
  // DOWNLOAD + OUVRIR
  // ------------------------------------------------------------
  Future<bool> openStorageFile({
    required String bucket,
    required String fileName,
  }) async {
    try {
      final bytes = await downloadFile(bucket: bucket, fileName: fileName);

      if (bytes == null) {
        return false;
      }

      final tempDir = await getTemporaryDirectory();

      final uniqueName = '${DateTime.now().microsecondsSinceEpoch}_$fileName';

      final localFile = File('${tempDir.path}/$uniqueName');

      await localFile.writeAsBytes(bytes);

      await OpenFilex.open(localFile.path);

      debug("Ouverture : ${localFile.path}");

      return true;
    } catch (e) {
      debug("Erreur openStorageFile() : $e");
      return false;
    }
  }

  // ------------------------------------------------------------
  // DOWNLOAD + ENREGISTRER SOUS
  // ------------------------------------------------------------
  Future<bool> saveStorageFile({
    required String bucket,
    required String fileName,
  }) async {
    try {
      final bytes = await downloadFile(bucket: bucket, fileName: fileName);

      if (bytes == null) {
        return false;
      }

      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Enregistrer sous',
        fileName: fileName,
      );

      if (savePath == null) {
        debug("Sauvegarde annulée");
        return false;
      }

      final localFile = File(savePath);

      await localFile.writeAsBytes(bytes);

      debug("Sauvegardé : ${localFile.path}");

      return true;
    } catch (e) {
      debug("Erreur saveStorageFile() : $e");
      return false;
    }
  }

  // MULTIPLATEFORME
  // Validation Windows effectuée.
  // Test réel Android, iOS et macOS requis.
}
