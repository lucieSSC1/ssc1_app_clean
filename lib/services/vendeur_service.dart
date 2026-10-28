import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vendeur_model.dart';

class VendeurService {
  final supabase = Supabase.instance.client;

  Future<List<Vendeur>> getAll() async {
    final response = await supabase
        .from('vendeur')
        .select()
        .order('nom', ascending: true);

    return (response as List).map((j) => Vendeur.fromJson(j)).toList();
  }

  Future<Vendeur?> getById(int id) async {
    final response = await supabase
        .from('vendeur')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Vendeur.fromJson(response);
  }

  Future<Vendeur> create(Vendeur v) async {
    final response = await supabase
        .from('vendeur')
        .insert(v.toJson())
        .select()
        .single();

    return Vendeur.fromJson(response);
  }

  Future<Vendeur> update(Vendeur v) async {
    final response = await supabase
        .from('vendeur')
        .update(v.toJson())
        .eq('id', v.id!) // ✔ Correction ici
        .select()
        .single();

    return Vendeur.fromJson(response);
  }

  Future<void> delete(int id) async {
    await supabase.from('vendeur').delete().eq('id', id);
  }
}
