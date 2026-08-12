/* ---------------------------------------------------------------------------
   CHEMIN : lib/api/journee_api.dart
   DESCRIPTION : API JOURNÉE (Structure 4)
   Basé sur la table SQL finale :
   date, heures_travaillees, objectif, description, suite, note
   --------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/journee_model.dart';

class JourneeApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // OBTENIR TOUTES LES JOURNÉES (rarement utilisé)
  // ---------------------------------------------------------------------------
  static Future<List<JourneeModel>> getJournees() async {
    final url = Uri.parse("$baseUrl/journee");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les journées");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => JourneeModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR UNE JOURNÉE PAR ID
  // ---------------------------------------------------------------------------
  static Future<JourneeModel> getJournee(int id) async {
    final url = Uri.parse("$baseUrl/journee/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger la journée");
    }

    return JourneeModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // OBTENIR LES JOURNÉES D'UNE ACTIVITÉ (bouton Détail)
  // ---------------------------------------------------------------------------
  static Future<List<JourneeModel>> getJourneesParActivite(int activId) async {
    final url = Uri.parse("$baseUrl/journee/activite/$activId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les journées de l'activité");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => JourneeModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR LES JOURNÉES D'UN PROJET (Journal du projet)
  // ---------------------------------------------------------------------------
  static Future<List<JourneeModel>> getJourneesParProjet(int projetId) async {
    final url = Uri.parse("$baseUrl/journee/projet/$projetId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les journées du projet");
    }

    final List data = jsonDecode(response.body);
    return data.map((e) => JourneeModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UNE JOURNÉE
  // ---------------------------------------------------------------------------
  static Future<int> insertJournee(JourneeModel j) async {
    final url = Uri.parse("$baseUrl/journee");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(j.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible d'ajouter la journée");
    }

    final data = jsonDecode(response.body);
    return data["id"];
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UNE JOURNÉE
  // ---------------------------------------------------------------------------
  static Future<void> updateJournee(JourneeModel j) async {
    final url = Uri.parse("$baseUrl/journee/${j.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(j.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible de modifier la journée");
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UNE JOURNÉE
  // ---------------------------------------------------------------------------
  static Future<void> deleteJournee(int id) async {
    final url = Uri.parse("$baseUrl/journee/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de supprimer la journée");
    }
  }
}