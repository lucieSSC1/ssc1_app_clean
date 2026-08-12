// ssc1_app/lib/services/programme_service.dart
//
// Service : Programme (version SSC1)
// ----------------------------------
// Gère la communication API pour la table SQL "programme".
//
// Champs SQL :
// - id
// - nom
// - desc
// - rem
// - cout
// - etablissement_id
// - glob_id
//
// Méthodes :
// - getAll()
// - getById()
// - create()
// - update()
// - delete()
//
// Ce fichier était vide dans structure 2 : il est créé pour SSC1.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/programme_model.dart';

class ProgrammeService {
  // IMPORTANT : adapter l’adresse selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/programme";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Programme>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Programme.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement programmes (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Programme?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Programme.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement programme (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Programme> create(Programme p) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Programme.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création programme (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Programme p) async {
    if (p.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${p.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour programme (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression programme (code ${response.statusCode})",
      );
    }
  }
}