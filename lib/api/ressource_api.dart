// -----------------------------------------------------------------------------
// CHEMIN : lib/api/ressource_api.dart
// -----------------------------------------------------------------------------
// API Ressource : CRUD complet pour la table ressource
// -----------------------------------------------------------------------------

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/ressource_model.dart';

class RessourceApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // GET : liste complète des ressources
  // ---------------------------------------------------------------------------
  static Future<List<RessourceModel>> getRessources() async {
    final url = Uri.parse("$baseUrl/ressource");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des ressources");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => RessourceModel.fromJson(json)).toList();
  }

  // ---------------------------------------------------------------------------
  // POST : ajouter une ressource
  // ---------------------------------------------------------------------------
  static Future<RessourceModel> createRessource(RessourceModel r) async {
    final url = Uri.parse("$baseUrl/ressource");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(r.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de la ressource");
    }

    return RessourceModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // PUT : modifier une ressource
  // ---------------------------------------------------------------------------
  static Future<RessourceModel> updateRessource(RessourceModel r) async {
    final url = Uri.parse("$baseUrl/ressource/${r.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(r.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de la ressource");
    }

    return RessourceModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // DELETE : supprimer une ressource
  // ---------------------------------------------------------------------------
  static Future<void> deleteRessource(int id) async {
    final url = Uri.parse("$baseUrl/ressource/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de la ressource");
    }
  }
}