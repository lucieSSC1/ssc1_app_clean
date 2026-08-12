// ssc1_app/lib/services/acquisition_service.dart
//
// Service : Acquisition (version SSC1)
// -------------------------------------
// Modernisation complète du fichier api_acquisition.dart de structure 2.
// - Classe non statique
// - Méthodes propres et cohérentes
// - Compatible avec acquisition_model.dart
// - Compatible avec structure 4
// - Compatible avec les spécifications fonctionnelles

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/acquisition_model.dart';

class AcquisitionService {
  // IMPORTANT : l'adresse doit être adaptée selon ton réseau
  final String baseUrl = "http://192.168.0.12:7000/api/acquisition";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Acquisition>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Acquisition.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement acquisitions (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Acquisition?> getById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));

    if (response.statusCode == 200) {
      return Acquisition.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 404) {
      return null;
    }

    throw Exception(
      "Erreur chargement acquisition (code ${response.statusCode})",
    );
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Acquisition> create(Acquisition acquisition) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(acquisition.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Acquisition.fromJson(jsonDecode(response.body));
    }

    throw Exception(
      "Erreur création acquisition (code ${response.statusCode})\n${response.body}",
    );
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Acquisition acquisition) async {
    if (acquisition.id == null) {
      throw Exception("Impossible de mettre à jour : id manquant");
    }

    final response = await http.put(
      Uri.parse("$baseUrl/${acquisition.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(acquisition.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception(
        "Erreur mise à jour acquisition (code ${response.statusCode})\n${response.body}",
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
        "Erreur suppression acquisition (code ${response.statusCode})",
      );
    }
  }
}