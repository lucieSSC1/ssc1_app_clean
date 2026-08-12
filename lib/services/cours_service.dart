// ssc1_app/lib/services/cours_service.dart
//
// Service : Cours (version SSC1)
// ------------------------------
// Gère la communication API pour la table SQL "cours".
//
// Champs SQL :
// - id
// - glob_id
// - code
// - nom
// - desc
// - prog_id
// - session
// - note_num
// - note_alpha
// - categ
// - remarque
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

import '../models/cours_model.dart';

class CoursService {
  // IMPORTANT : adapter l’adresse selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/cours";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Cours>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Cours.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement cours (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Cours?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Cours.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement cours (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Cours> create(Cours c) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(c.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Cours.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création cours (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Cours c) async {
    if (c.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${c.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(c.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour cours (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression cours (code ${response.statusCode})",
      );
    }
  }
}
