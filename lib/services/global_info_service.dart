// ============================================================
// FICHIER : lib/services/global_info_service.dart
// Service Supabase pour la table glob_info
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/global_info_model.dart';

class GlobalInfoService {
  final supabase = Supabase.instance.client;

  // ------------------------------------------------------------
  // GET BY ID
  // ------------------------------------------------------------
  Future<GlobalInfo?> getById(int id) async {
    final response = await supabase
        .from('glob_info')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return GlobalInfo.fromJson(response);
  }

  // ------------------------------------------------------------
  // CREATE
  // ------------------------------------------------------------
  Future<GlobalInfo> create(GlobalInfo info) async {
    final response = await supabase
        .from('glob_info')
        .insert(info.toJson())
        .select()
        .maybeSingle();

    if (response == null) {
      throw Exception("Erreur création GlobalInfo");
    }

    return GlobalInfo.fromJson(response);
  }

  // ------------------------------------------------------------
  // UPDATE
  // ------------------------------------------------------------
  Future<void> update(GlobalInfo info) async {
    if (info.id == null) {
      throw Exception("GlobalInfo.id est null dans update()");
    }

    await supabase.from('glob_info').update(info.toJson()).eq('id', info.id!);
  }

  // ------------------------------------------------------------
  // DELETE
  // ------------------------------------------------------------
  Future<void> delete(int id) async {
    await supabase.from('glob_info').delete().eq('id', id);
  }
}
