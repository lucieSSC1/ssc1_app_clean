/* ---------------------------------------------------------------------------
   CHEMIN : lib/api/tache_api.dart
   DESCRIPTION : API TÂCHE (Structure 4)
   --------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/tache_model.dart';

class TacheApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // OBTENIR TOUTES LES TÂCHES D'UN LOT
  // ---------------------------------------------------------------------------
  static Future<List<TacheModel>> getTachesByLot(int lotId) async {
    final url = Uri.parse("$baseUrl/tache/lot/$lotId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les tâches");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => TacheModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR UNE TÂCHE PAR ID
  // ---------------------------------------------------------------------------
  static Future<TacheModel> getTache(int id) async {
    final url = Uri.parse("$baseUrl/tache/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger la tâche");
    }

    return TacheModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UNE TÂCHE
  // ---------------------------------------------------------------------------
  static Future<int> insertTache(TacheModel t) async {
    final url = Uri.parse("$baseUrl/tache");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(t.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible d'ajouter la tâche");
    }

    final data = jsonDecode(response.body);
    return data["id"];
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UNE TÂCHE
  // ---------------------------------------------------------------------------
  static Future<void> updateTache(TacheModel t) async {
    final url = Uri.parse("$baseUrl/tache/${t.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(t.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible de modifier la tâche");
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UNE TÂCHE
  // ---------------------------------------------------------------------------
  static Future<void> deleteTache(int id) async {
    final url = Uri.parse("$baseUrl/tache/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de supprimer la tâche");
    }
  }
}