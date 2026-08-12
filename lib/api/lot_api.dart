/* ---------------------------------------------------------------------------
   CHEMIN : lib/api/lot_api.dart
   DESCRIPTION : API LOT (Structure 4)
   --------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/lot_model.dart';

class LotApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // OBTENIR TOUS LES LOTS D'UN PROJET
  // ---------------------------------------------------------------------------
  static Future<List<LotModel>> getLotsByProjet(int projetId) async {
    final url = Uri.parse("$baseUrl/lot/projet/$projetId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger les lots");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => LotModel.fromJson(e)).toList();
  }

  // ---------------------------------------------------------------------------
  // OBTENIR UN LOT PAR ID
  // ---------------------------------------------------------------------------
  static Future<LotModel> getLot(int id) async {
    final url = Uri.parse("$baseUrl/lot/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de charger le lot");
    }

    return LotModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // AJOUTER UN LOT
  // ---------------------------------------------------------------------------
  static Future<int> insertLot(LotModel lot) async {
    final url = Uri.parse("$baseUrl/lot");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lot.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible d'ajouter le lot");
    }

    final data = jsonDecode(response.body);
    return data["id"];
  }

  // ---------------------------------------------------------------------------
  // MODIFIER UN LOT
  // ---------------------------------------------------------------------------
  static Future<void> updateLot(LotModel lot) async {
    final url = Uri.parse("$baseUrl/lot/${lot.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lot.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Impossible de modifier le lot");
    }
  }

  // ---------------------------------------------------------------------------
  // SUPPRIMER UN LOT
  // ---------------------------------------------------------------------------
  static Future<void> deleteLot(int id) async {
    final url = Uri.parse("$baseUrl/lot/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Impossible de supprimer le lot");
    }
  }
}