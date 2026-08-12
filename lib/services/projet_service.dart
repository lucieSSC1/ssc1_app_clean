// ssc1_app/lib/services/projet_service.dart
//
// Service : Projet (module Gestionnaire de projets - SSC1)
// --------------------------------------------------------
// Gère la communication API pour la table SQL "projet".
//
// Champs SQL :
// - id
// - glob_id
// - titre
// - categorie_id
// - domaine
// - description
// - objectif
// - remarque (notes)
// - tag
// - directory
//
// Gestion d’erreurs :
// - try/catch autour de chaque requête
// - messages explicites pour l’UI
// - vérification stricte des statusCode

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/projet_model.dart';

class ProjetService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/projet";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Projet>> getAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode != 200) {
        throw Exception(
          "Erreur ${response.statusCode} lors du chargement des projets.",
        );
      }

      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Projet.fromJson(j)).toList();
    } catch (e) {
      throw Exception("Impossible de charger les projets : $e");
    }
  }

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<Projet?> getById(int id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 404) return null;

      if (response.statusCode != 200) {
        throw Exception(
          "Erreur ${response.statusCode} lors du chargement du projet #$id.",
        );
      }

      return Projet.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("Impossible de charger le projet #$id : $e");
    }
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<Projet> create(Projet projet) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(projet.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(
          "Erreur ${response.statusCode} lors de la création du projet.\n${response.body}",
        );
      }

      return Projet.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception("Impossible de créer le projet : $e");
    }
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(Projet projet) async {
    if (projet.id == null) {
      throw Exception("Impossible de mettre à jour un projet sans id.");
    }

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/${projet.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(projet.toJson()),
      );

      if (response.statusCode != 204) {
        throw Exception(
          "Erreur ${response.statusCode} lors de la mise à jour du projet #${projet.id}.\n${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Impossible de mettre à jour le projet : $e");
    }
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------
  Future<void> delete(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));

      if (response.statusCode != 204) {
        throw Exception(
          "Erreur ${response.statusCode} lors de la suppression du projet #$id.",
        );
      }
    } catch (e) {
      throw Exception("Impossible de supprimer le projet : $e");
    }
  }
}
