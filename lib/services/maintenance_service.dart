// lib/services/maintenance_service.dart
//
// Service : Maintenance (version SSC1)
// ------------------------------------
// CRUD complet
// Liste des maintenances d'une acquisition
// Tri chronologique par date
// Compatible Supabase
//
// Table maintenance
// -----------------
// id
// acqu_id
// date
// a_effectuer
// reparateur
// effectue
// duree
// pieces
// cout
// facture
// ------------------------------------

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/maintenance_model.dart';

class MaintenanceService {
  final supabase = Supabase.instance.client;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-MAINT-SERVICE: $msg");
    if (data != null) {
      print("DEBUG-DATA: $data");
    }
  }

  // ------------------------------------------------------------
  // LISTE DES MAINTENANCES D'UNE ACQUISITION
  // ------------------------------------------------------------
  Future<List<MaintenanceModel>> getByAcquisition(int acquId) async {
    _debug("getByAcquisition($acquId)");

    final data = await supabase
        .from('maintenance')
        .select('*')
        .eq('acqu_id', acquId)
        .order('date', ascending: true);

    return (data as List)
        .map((e) => MaintenanceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // OBTENIR PAR ID
  // ------------------------------------------------------------
  Future<MaintenanceModel?> getById(int id) async {
    _debug("getById($id)");

    final data = await supabase
        .from('maintenance')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return MaintenanceModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // CRÉER
  // ------------------------------------------------------------
  Future<MaintenanceModel> create(MaintenanceModel maintenance) async {
    _debug("create()", maintenance.toJson());

    final data = await supabase
        .from('maintenance')
        .insert(maintenance.toJson())
        .select('*')
        .single();

    return MaintenanceModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // METTRE À JOUR
  // ------------------------------------------------------------
  Future<MaintenanceModel> update(MaintenanceModel maintenance) async {
    if (maintenance.id == null) {
      throw Exception("Impossible de modifier une maintenance sans ID.");
    }

    _debug("update(${maintenance.id})");

    final data = await supabase
        .from('maintenance')
        .update(maintenance.toJson())
        .eq('id', maintenance.id!)
        .select('*')
        .single();

    return MaintenanceModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // SUPPRIMER
  // ------------------------------------------------------------
  Future<void> delete(int id) async {
    _debug("delete($id)");

    await supabase.from('maintenance').delete().eq('id', id);
  }

  // ------------------------------------------------------------
  // COMPTER LES MAINTENANCES
  // ------------------------------------------------------------
  Future<int> countByAcquisition(int acquId) async {
    final data = await supabase
        .from('maintenance')
        .select('id')
        .eq('acqu_id', acquId);

    return (data as List).length;
  }
}
