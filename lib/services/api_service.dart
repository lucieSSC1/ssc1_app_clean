// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ============================
  //  URL de base de ton backend
  // ============================
  static const String baseUrl = "http://localhost:3000"; 
  // Change si ton backend SSC1 est ailleurs

  // ============================
  //  GET
  // ============================
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.get(url);

    _checkStatus(response);

    return jsonDecode(response.body);
  }

  // ============================
  //  POST
  // ============================
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    _checkStatus(response);

    return jsonDecode(response.body);
  }

  // ============================
  //  PUT
  // ============================
  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    _checkStatus(response);

    return jsonDecode(response.body);
  }

  // ============================
  //  DELETE
  // ============================
  static Future<void> delete(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");

    final response = await http.delete(url);

    _checkStatus(response);
  }

  // ============================
  //  Vérification des erreurs
  // ============================
  static void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        "Erreur API (${response.statusCode}) : ${response.body}",
      );
    }
  }
}

