// ssc1_app/lib/services/reference_service.dart
//
// Service : Reference (version SSC1)
// ----------------------------------
// Gère la communication API pour les références documentaires.
// Basé sur reference_model.dart et la table SQL "reference".
//
// Méthodes :
// - getAll()
// - getById()
// - create()
// - update()
// - delete()
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/reference_model.dart';

class ReferenceService {
  // IMPORTANT : adapter l’adresse selon ton réseau
  final String baseUrl = "http://192.168.0.12:7000/api/reference";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Reference>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Reference.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement références (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Reference?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Reference.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement référence (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Reference> create(Reference reference) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reference.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Reference.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création référence (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Reference reference) async {
    if (reference.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${reference.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reference.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour référence (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression référence (code ${response.statusCode})",
      );
    }
  }
}
