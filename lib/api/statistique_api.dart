// -----------------------------------------------------------------------------
// CHEMIN : lib/api/statistiques_api.dart
// -----------------------------------------------------------------------------
// API Statistiques (Structure 4)
// - Statistiques d'un projet
// - Statistiques multiprojet par domaine (A à E)
// -----------------------------------------------------------------------------

import 'dart:convert';
import 'package:http/http.dart' as http;

class StatistiquesApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // STATISTIQUES D'UN PROJET
  // ---------------------------------------------------------------------------
  static Future<Map<String, dynamic>> getStatsProjet(int projetId) async {
    final url = Uri.parse("$baseUrl/statistiques/projet/$projetId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les statistiques du projet");
    }

    return jsonDecode(response.body);
  }

  // ---------------------------------------------------------------------------
  // STATISTIQUES MULTIPROJET PAR DOMAINE (A à E)
  // ---------------------------------------------------------------------------
  static Future<Map<String, double>> getStatsMultiprojetDomaine(
    DateTime debut,
    DateTime fin,
  ) async {
    final debutStr = debut.toIso8601String().split('T')[0];
    final finStr = fin.toIso8601String().split('T')[0];

    final url = Uri.parse(
      "$baseUrl/statistiques/multiprojet/domaine?debut=$debutStr&fin=$finStr",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
          "Impossible de charger les statistiques multiprojet domaine");
    }

    final data = jsonDecode(response.body);

    // Convertir en Map<String, double>
    return data.map<String, double>(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );
  }
}