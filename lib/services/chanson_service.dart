// ssc1_app/lib/services/chanson_service.dart
//
// Service : Chanson (module Loisir - SSC1)
// ----------------------------------------
// Gère la communication API pour la table SQL "chanson".
//
// Champs SQL :
// - id
// - titre
// - auteur
// - compositeur
// - interprete
// - paroles_url
// - notes

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chanson_model.dart';

class ChansonService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/chanson";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Chanson>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Chanson.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement chansons (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Chanson?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Chanson.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement chanson (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Chanson> create(Chanson chanson) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(chanson.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Chanson.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création chanson (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Chanson chanson) async {
    if (chanson.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${chanson.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(chanson.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour chanson (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression chanson (code ${response.statusCode})",
      );
    }
  }
}