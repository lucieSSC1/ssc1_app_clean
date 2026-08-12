// ssc1_app/lib/services/prospect_service.dart
//
// Service : Prospect (version SSC1)
// ---------------------------------
// Gère la communication API pour la table SQL "prospect".
//
// Champs SQL :
// - id
// - nom
// - entreprise
// - telephone
// - courriel
// - site_url
// - adresse
// - ville
// - prov
// - pays
// - commentaire
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/prospect_model.dart';

class ProspectService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/prospect";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Prospect>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Prospect.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement prospects (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Prospect?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Prospect.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement prospect (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Prospect> create(Prospect p) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Prospect.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création prospect (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Prospect p) async {
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
        "Erreur mise à jour prospect (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression prospect (code ${response.statusCode})",
      );
    }
  }
}
