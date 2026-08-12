// ============================================================
// FICHIER : lib/services/event_categ_service.dart
// Service Catégories — Compact + Propre
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_categ_model.dart';

class EventCategService {
  final supabase = Supabase.instance.client;

  Future<List<EventCateg>> getAll() async {
    final data = await supabase.from('event_categ').select('*').order('id');

    return (data as List)
        .map((e) => EventCateg.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
