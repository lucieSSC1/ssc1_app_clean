// ============================================================
// FICHIER : lib/services/global_info_service.dart
// Service GlobalInfo — Version SSC1 finale (avec fromMap)
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/global_info_model.dart';

class GlobalInfoService {
  final supabase = Supabase.instance.client;

  // OBTENIR PAR ID
  Future<GlobalInfo?> getById(int id) async {
    final data = await supabase
        .from('glob_info')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;
    return GlobalInfo.fromMap(data as Map<String, dynamic>);
  }

  // CRÉER
  Future<GlobalInfo> create(GlobalInfo info) async {
    final data = await supabase
        .from('glob_info')
        .insert(info.toJson())
        .select('*')
        .maybeSingle();

    if (data == null) {
      throw Exception("Erreur création glob_info : réponse vide");
    }

    return GlobalInfo.fromMap(data as Map<String, dynamic>);
  }

  // METTRE À JOUR (corrigé pour éviter PGRST116)
  Future<GlobalInfo> update(GlobalInfo info) async {
    // 1) UPDATE sans select
    final updateResult = await supabase
        .from('glob_info')
        .update(info.toJson())
        .eq('id', info.id!);

    // 2) GET dans une requête séparée
    final data = await supabase
        .from('glob_info')
        .select('*')
        .eq('id', info.id!)
        .maybeSingle();

    if (data == null) {
      throw Exception("Erreur update glob_info : GET après update vide");
    }

    return GlobalInfo.fromMap(data as Map<String, dynamic>);
  }

  // SUPPRIMER
  Future<void> delete(int id) async {
    await supabase.from('glob_info').delete().eq('id', id);
  }
}
