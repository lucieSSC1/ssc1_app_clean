// ssc1_app/lib/services/demarche_service.dart
//
// Service : Démarche (version SSC1, sans accents dans les champs)
// ---------------------------------------------------------------
// Gère la communication API pour la table SQL "demarche".
//
// Champs SQL :
// - id
// - date
// - domaine
// - service
// - service_details
// - mot_cle1
// - mot_cle2
// - mot_cle3
// - prosp_id
// - pending
// - entente
// - interactions
// - lettre_url
// - cv_url
// - preparation_url
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/demarche_model.dart';

class DemarcheService {
  // Adapter selon ton environnement
  final String baseUrl = "http://192.168.0.12:7000/api/demarche";

  // ------------------------------------------------------------
  // GET ALL
  // ------------------------------------------------------------
  Future<List<Demarche>> getAll() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((j) => Demarche.fromJson(j)).toList();
    }

    throw Exception(
      "Erreur chargement démarches (code ${response.status