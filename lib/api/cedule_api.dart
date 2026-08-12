/* -----------------------------------------------------------------------------
   FICHIER : lib/api/cedule_api.dart
   STRUCTURE 4 — API CÉDULE

   Routes utilisées :
     GET    /cedule
     GET    /cedule/:id
     GET    /cedule/activite/:activ_id
     POST   /cedule
     PUT    /cedule/:id
     DELETE /cedule/:id
     PUT    /cedule/:id/terminee

   Modèle utilisé : CeduleModel (Structure 4)
   ----------------------------------------------------------------------------- */

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cedule_model.dart';

class CeduleApi {
  static const String baseUrl = "http://localhost:3000";

  // ---------------------------------------------------------------------------
  // GET : toutes les cédules
  // ---------------------------------------------------------------------------
  static Future<List<CeduleModel>> getCedules() async {
    final url = Uri.parse("$baseUrl/cedule");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des cédules");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => CeduleModel.fromJson(json)).toList();
  }

  // ---------------------------------------------------------------------------
  // GET : cédules d'une activité
  // ---------------------------------------------------------------------------
  static Future<List<CeduleModel>> getCedulesParActivite(int activId) async {
    final url = Uri.parse("$baseUrl/cedule/activite/$activId");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du chargement des cédules");
    }

    final List data = jsonDecode(response.body);

    return data.map((json) => CeduleModel.fromJson(json)).toList();
  }

  // ---------------------------------------------------------------------------
  // GET : cédule par ID
  // ---------------------------------------------------------------------------
  static Future<CeduleModel?> getCedule(int id) async {
    final url = Uri.parse("$baseUrl/cedule/$id");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    return CeduleModel.fromJson(jsonDecode(response.body));
  }

  // ---------------------------------------------------------------------------
  // POST : créer une cédule
  // ---------------------------------------------------------------------------
  static Future<int> createCedule(CeduleModel c) async {
    final url = Uri.parse("$baseUrl/cedule");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(c.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erreur lors de la création de la cédule");
    }

    final data = jsonDecode(response.body);
    return data['id'];
  }

  // ---------------------------------------------------------------------------
  // PUT : mettre à jour une cédule
  // ---------------------------------------------------------------------------
  static Future<void> updateCedule(CeduleModel c) async {
    final url = Uri.parse("$baseUrl/cedule/${c.id}");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(c.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la mise à jour de la cédule");
    }
  }

  // ---------------------------------------------------------------------------
  // PUT : changer le statut "terminée"
  // ---------------------------------------------------------------------------
  static Future<void> setTerminee(int id, bool value) async {
    final url = Uri.parse("$baseUrl/cedule/$id/terminee");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'terminee': value}),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur lors du changement d'état de la cédule");
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE : supprimer une cédule
  // ---------------------------------------------------------------------------
  static Future<void> deleteCedule(int id) async {
    final url = Uri.parse("$baseUrl/cedule/$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de la cédule");
    }
  }
}