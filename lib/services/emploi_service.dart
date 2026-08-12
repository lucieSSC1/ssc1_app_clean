// ssc1_app/lib/services/emploi_service.dart
//
// Service : Emploi (version SSC1)
// -------------------------------
// Gère la communication API pour la table SQL "emploi".
//
// Champs SQL :
// - id
// - glob_id
// - fonction
// - employeur_id
// - taches
// - no_contrat
// - taux_horaire
// - commentaire
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

import '../models/emploi_model.dart';

class EmploiService {
  // IMPORTANT : adapter l’adresse selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/emploi";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Emploi>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Emploi.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement emplois (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Emploi?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Emploi.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement emploi (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Emploi> create(Emploi e) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(e.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Emploi.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création emploi (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Emploi e) async {
    if (e.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${e.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(e.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour emploi (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression emploi (code ${response.statusCode})",
      );
    }
  }
}
