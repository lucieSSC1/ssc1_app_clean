// ssc1_app/lib/services/film_service.dart
//
// Service : Film (module Loisir - SSC1)
// -------------------------------------
// Gère la communication API pour la table SQL "film".
//
// Champs SQL :
// - id
// - titre
// - description
// - acteurs
// - realisateur
// - affiche_url
// - notes

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/film_model.dart';

class FilmService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/film";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Film>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Film.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement films (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Film?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Film.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement film (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Film> create(Film film) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(film.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Film.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création film (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Film film) async {
    if (film.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${film.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(film.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour film (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression film (code ${response.statusCode})",
      );
    }
  }
}