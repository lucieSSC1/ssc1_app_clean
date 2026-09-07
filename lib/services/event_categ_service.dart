// ============================================================
// FICHIER : lib/services/event_categ_service.dart
// Service Catégories — Version SSC1 (compact + logs + robuste)
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_categ_model.dart';

class EventCategService {
  final supabase = Supabase.instance.client;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-CATEG: $msg");
    if (data != null) print("DEBUG-CATEG-DATA: $data");
  }

  // ------------------------------------------------------------
  // GET ALL — Liste des catégories
  // ------------------------------------------------------------
  Future<List<EventCateg>> getAll() async {
    _debug("getAll() appelé");

    final data = await supabase.from('event_categ').select('*').order('id');

    _debug("Résultat getAll()", data);

    return (data as List)
        .map((e) => EventCateg.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
