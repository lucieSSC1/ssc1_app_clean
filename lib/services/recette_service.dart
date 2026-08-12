// ssc1_app/lib/services/recette_service.dart
//
// Service : Recette (module Loisir - SSC1)
// ----------------------------------------
// Gère la communication API pour la table SQL "recette".
//
// Champs SQL :
// - id
// - nom
// - categorie   (ENUM)
// - source
// - recette_url
// - notes

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/recette_model.dart';

class RecetteService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/recette";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Recette>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Recette.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement recettes (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Recette?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Recette.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement recette (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Recette> create(Recette recette) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recette.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Recette.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création recette (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Recette recette) async {
    if (recette.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${recette.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recette.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour recette (code ${response.statusCode})\n${response.body}",
      );
    }
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------
  Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur suppression recette (code ${response.statusCode})",
      );
    }
  }
}