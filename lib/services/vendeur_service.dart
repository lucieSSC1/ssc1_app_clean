// lib/services/vendeur_service.dart

import '../models/vendeur_model.dart';
import 'api_service.dart';

class VendeurService {
  Future<List<Vendeur>> getAll() async {
    final response = await ApiService.get("/vendeur");
    return (response as List).map((j) => Vendeur.fromJson(j)).toList();
  }

  Future<Vendeur?> getById(int id) async {
    final response = await ApiService.get("/vendeur/$id");
    return Vendeur.fromJson(response);
  }

  Future<Vendeur> create(Vendeur v) async {
    final response = await ApiService.post("/vendeur", v.toJson());
    return Vendeur.fromJson(response);
  }

  Future<Vendeur> update(Vendeur v) async {
    final response = await ApiService.put("/vendeur/${v.id}", v.toJson());
    return Vendeur.fromJson(response);
  }

  Future<void> delete(int id) async {
    await ApiService.delete("/vendeur/$id");
  }
}
