// -----------------------------------------------------------------------------
// CHEMIN : lib/api/proj_info_api.dart
// -----------------------------------------------------------------------------
// API pour proj_info : lecture et sauvegarde du texte long d’un projet
// -----------------------------------------------------------------------------

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/proj_info_model.dart';

class ProjInfoApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // GET : obtenir le texte proj_info d’un projet
  // ---------------------------------------------------------------------------
  static Future<ProjInfoModel?> getProjInfo(int projetId) async {
    final url = Uri.parse("$baseUrl/proj_info?projet_id=$projetId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement de proj_info");
    }

    final List data = jsonDecode(response.body);

    if (data.isEmpty) return null;

    return ProjInfoModel.fromJson(data.first);
  }

  // ---------------------------------------------------------------------------
  // POST : créer un enregistrement proj_info
  // ---------------------------------------------------------------------------
  static Future<ProjInfoModel> createProjInfo(ProjInfoModel info) async {
    final url = Uri.parse("$baseUrl/proj_info");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(info.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de proj_info");
    }

    return ProjInfoModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // PUT : mettre à jour proj_info
  // ---------------------------------------------------------------------------
  static Future<ProjInfoModel> updateProjInfo(ProjInfoModel info) async {
    final url = Uri.parse("$baseUrl/proj_info/${info.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(info.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de proj_info");
    }

    return ProjInfoModel.fromJson(jsonDecode(response.body));
  }
}