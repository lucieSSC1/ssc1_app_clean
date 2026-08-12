// ssc1_app/lib/services/identite_service.dart
//
// Service : Identite
// -------------------
// Gère le chargement et la sauvegarde de l’identité de l’utilisateur.
// L’identité contient :
// - prenom
// - nom
// - dateNaissance
// - lieuNaissance
// - nationalite
//
// Ce module est volontairement simple :
// Il n’y a qu’une seule identité dans l’application.

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/identite_model.dart';

class IdentiteService {
  final String baseUrl = "http://localhost:3000/identite";

  // ------------------------------------------------------------
  // GET (il n’y a qu’une seule identité)
  // ------------------------------------------------------------
  Future<Identite?> getIdentite() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return Identite.fromJson(jsonDecode(response.body));
    }

    return null;
  }

  // ------------------------------------------------------------
  // UPDATE (ou CREATE si nécessaire)
  // ------------------------------------------------------------
  Future<void> saveIdentite(Identite identite) async {
    final response = await http.put(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(identite.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erreur sauvegarde identité : ${response.body}");
    }
  }
}