/* ---------------------------------------------------------------------------
   CHEMIN : lib/api/activite_api.dart
   DESCRIPTION : API ACTIVITÉ (Structure 4)
   --------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/activite_model.dart';

class ActiviteApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // OBTENIR TOUTES LES ACTIVITÉS D'UNE TÂCHE
  // ---------------------------------------------------------------------------
  static Future<List<ActiviteModel>> getActivitesByTache(int tacheId) async {
    final url = Uri.parse("$baseUrl/activite/tache/$tacheId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les activités");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => ActiviteModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR UNE ACTIVITÉ PAR ID
  // ---------------------------------------------------------------------------
  static Future<ActiviteModel> getActivite(int id) async {
    final url = Uri.parse("$baseUrl/activite/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger l'activité");
    }

    return ActiviteModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  static Future<int> insertActivite(ActiviteModel a) async {
    final url = Uri.parse("$baseUrl/activite");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(a.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible d'ajouter l'activité");
    }

    final data = jsonDecode(response.body);
    return data["id"];
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  static Future<void> updateActivite(ActiviteModel a) async {
    final url = Uri.parse("$baseUrl/activite/${a.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(a.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible de modifier l'activité");
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UNE ACTIVITÉ
  // ---------------------------------------------------------------------------
  static Future<void> deleteActivite(int id) async {
    final url = Uri.parse("$baseUrl/activite/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de supprimer l'activité");
    }
  }
}