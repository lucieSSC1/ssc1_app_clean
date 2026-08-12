// ssc1_app/lib/services/residences_service.dart
//
// Service : Residence (version SSC1)
// ----------------------------------
// Gère la communication API pour les résidences.
// Basé sur residence_model.dart et la table SQL residences.
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

import '../models/residence_model.dart';

class ResidenceService {
  // IMPORTANT : adapter l’adresse selon ton réseau
  final String baseUrl = "http://192.168.0.12:7000/api/residence";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Residence>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Residence.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement résidences (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Residence?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Residence.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement résidence (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Residence> create(Residence residence) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(residence.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Residence.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création résidence (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Residence residence) async {
    if (residence.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${residence.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(residence.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour résidence (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression résidence (code ${response.statusCode})",
      );
    }
  }
}