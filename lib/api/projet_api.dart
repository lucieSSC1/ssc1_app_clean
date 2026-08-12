// -----------------------------------------------------------------------------
// CHEMIN : lib/api/projet_api.dart
// -----------------------------------------------------------------------------
// API PROJET (Structure 4)
// -----------------------------------------------------------------------------

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/projet_model.dart';

class ProjetApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // OBTENIR TOUS LES PROJETS
  // ---------------------------------------------------------------------------
  static Future<List<ProjetModel>> getProjets() async {
    final url = Uri.parse("$baseUrl/projet");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les projets");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => ProjetModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR UN PROJET PAR ID
  // ---------------------------------------------------------------------------
  static Future<ProjetModel> getProjet(int id) async {
    final url = Uri.parse("$baseUrl/projet/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger le projet");
    }

    return ProjetModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UN PROJET
  // ---------------------------------------------------------------------------
  static Future<int> insertProjet(ProjetModel p) async {
    final url = Uri.parse("$baseUrl/projet");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible d'ajouter le projet");
    }

    final data = jsonDecode(response.body);
    return data["id"];
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UN PROJET
  // ---------------------------------------------------------------------------
  static Future<void> updateProjet(ProjetModel p) async {
    final url = Uri.parse("$baseUrl/projet/${p.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible de modifier le projet");
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UN PROJET
  // ---------------------------------------------------------------------------
  static Future<void> deleteProjet(int id) async {
    final url = Uri.parse("$baseUrl/projet/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de supprimer le projet");
    }
  }
}