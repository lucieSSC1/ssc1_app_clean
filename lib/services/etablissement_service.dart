// ssc1_app/lib/services/etablissement_service.dart
//
// Service : Établissement (version SSC1)
// --------------------------------------
// Gère la communication API pour la table SQL "etablissement".
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

import '../models/etablissement_model.dart';

class EtablissementService {
  // IMPORTANT : adapter l’adresse selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/etablissement";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Etablissement>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Etablissement.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement établissements (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Etablissement?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Etablissement.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement établissement (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Etablissement> create(Etablissement etab) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(etab.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Etablissement.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création établissement (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Etablissement etab) async {
    if (etab.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${etab.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(etab.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour établissement (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression établissement (code ${response.statusCode})",
      );
    }
  }
}