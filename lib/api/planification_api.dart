/* -----------------------------------------------------------------------------
   FICHIER : lib/api/planification_api.dart
   STRUCTURE 4 — API Planification

   Routes utilisées :
     GET    /planification
     GET    /planification/:id
     GET    /planification/activite/:activ_id
     POST   /planification
     PUT    /planification/:id
     DELETE /planification/:id
     PUT    /planification/:id/terminee

   Modèle utilisé : PlanificationModel (Structure 4)
   ----------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/planification_model.dart';

class PlanificationApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // GET : toutes les planifications
  // ---------------------------------------------------------------------------
  static Future<List<PlanificationModel>> getPlanifications() async {
    final url = Uri.parse("$baseUrl/planification");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des planifications");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => PlanificationModel.fromJson(json)).toList();
  }

  // ---------------------------------------------------------------------------
  // GET : planifications d'une activité
  // ---------------------------------------------------------------------------
  static Future<List<PlanificationModel>> getPlanificationsParActivite(
      int activId) async {
    final url = Uri.parse("$baseUrl/planification/activite/$activId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des planifications");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => PlanificationModel.fromJson(json)).toList();
  }

  // ---------------------------------------------------------------------------
  // GET : planification par ID
  // ---------------------------------------------------------------------------
  static Future<PlanificationModel?> getPlanification(int id) async {
    final url = Uri.parse("$baseUrl/planification/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    return PlanificationModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // POST : créer une planification
  // ---------------------------------------------------------------------------
  static Future<int> createPlanification(PlanificationModel p) async {
    final url = Uri.parse("$baseUrl/planification");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de la planification");
    }

    final data = jsonDecode(response.body);
    return data['id'];
  }

  // ---------------------------------------------------------------------------
  // PUT : mettre à jour une planification
  // ---------------------------------------------------------------------------
  static Future<void> updatePlanification(PlanificationModel p) async {
    final url = Uri.parse("$baseUrl/planification/${p.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(p.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de la planification");
    }
  }

  // ---------------------------------------------------------------------------
  // PUT : changer le statut "terminée"
  // ---------------------------------------------------------------------------
  static Future<void> setTerminee(int id, bool value) async {
    final url = Uri.parse("$baseUrl/planification/$id/terminee");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'terminee': value}),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du changement d'état de la planification");
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE : supprimer une planification
  // ---------------------------------------------------------------------------
  static Future<void> deletePlanification(int id) async {
    final url = Uri.parse("$baseUrl/planification/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de la planification");
    }
  }
}