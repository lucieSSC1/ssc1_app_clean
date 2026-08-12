// ssc1_app/lib/services/ecrit_service.dart
//
// Service : Écrit (module Loisir - SSC1)
// --------------------------------------
// Gère la communication API pour la table SQL "ecrit".
//
// Champs SQL :
// - id
// - titre
// - type
// - auteur
// - texte_url
// - notes

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ecrit_model.dart';

class EcritService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/ecrit";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Ecrit>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Ecrit.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement écrits (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Ecrit?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Ecrit.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement écrit (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Ecrit> create(Ecrit ecrit) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ecrit.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Ecrit.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création écrit (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Ecrit ecrit) async {
    if (ecrit.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${ecrit.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(ecrit.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour écrit (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression écrit (code ${response.statusCode})",
      );
    }
  }
}