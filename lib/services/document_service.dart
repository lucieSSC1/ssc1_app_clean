// lib/services/document_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

import '../models/document.dart';
import 'api_service.dart';

class DocumentService {
  // ============================
  //  GET /document
  // ============================
  Future<List<DocumentSSC1>> getAll() async {
    final response = await ApiService.get("/document");

    return (response as List)
        .map((json) => DocumentSSC1.fromJson(json))
        .toList();
  }

  // ============================
  //  GET /document/{id}
  // ============================
  Future<DocumentSSC1?> get(int id) async {
    final response = await ApiService.get("/document/$id");
    return DocumentSSC1.fromJson(response);
  }

  // ============================
  //  POST /document
  // ============================
  Future<DocumentSSC1> create(DocumentSSC1 doc) async {
    final response = await ApiService.post("/document", doc.toJson());
    return DocumentSSC1.fromJson(response);
  }

  // ============================
  //  PUT /document/{id}
  // ============================
  Future<DocumentSSC1> update(DocumentSSC1 doc) async {
    final response = await ApiService.put("/document/${doc.id}", doc.toJson());
    return DocumentSSC1.fromJson(response);
  }

  // ============================
  //  DELETE /document/{id}
  // ============================
  Future<void> delete(int id) async {
    await ApiService.delete("/document/$id");
  }

  // ============================
  //  POST /document/recherche
  // ============================
  Future<List<DocumentSSC1>> search(
    String titre,
    String mot1,
    String mot2,
    String mot3,
    String mode,
  ) async {
    final data = {
      "titre": titre,
      "mot_cle1": mot1,
      "mot_cle2": mot2,
      "mot_cle3": mot3,
      "mode": mode,
    };

    final response = await ApiService.post("/document/recherche", data);

    return (response as List)
        .map((json) => DocumentSSC1.fromJson(json))
        .toList();
  }

  // ============================
  //  Upload fichier (local ? URL)
  // ============================
  Future<String?> uploadFile() async {
    // S�lection du fichier
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return null;

    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    // Envoi vers ton backend (ou Supabase plus tard)
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("${ApiService.baseUrl}/upload"),
    );

    request.files.add(
      await http.MultipartFile.fromPath("file", file.path, filename: fileName),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json["url"]; // URL du fichier
    }

    return null;
  }
}
