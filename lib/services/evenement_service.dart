// ============================================================
// FICHIER : lib/services/evenement_service.dart
// Service Événement — Version JOIN glob_info + DEBUG complet
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/evenement_model.dart';

class EvenementService {
  final supabase = Supabase.instance.client;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-SERVICE: $msg");
    if (data != null) print("DEBUG-DATA: $data");
  }

  // ------------------------------------------------------------
  // LISTER TOUS LES ÉVÉNEMENTS (avec glob_info)
  // ------------------------------------------------------------
  Future<List<EvenementModel>> getAllEvenements() async {
    _debug("getAllEvenements() appelé");

    final data = await supabase
        .from('evenement')
        .select('*, glob_info!evenement_glob_id_fkey(debut, fin, type)')
        .order('id');

    _debug("Résultat getAllEvenements()", data);

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // OBTENIR UN ÉVÉNEMENT PAR ID (avec glob_info)
  // ------------------------------------------------------------
  Future<EvenementModel?> getEvenementById(int id) async {
    _debug("getEvenementById($id)");

    final data = await supabase
        .from('evenement')
        .select('*, glob_info!evenement_glob_id_fkey(debut, fin, type)')
        .eq('id', id)
        .maybeSingle();

    _debug("Résultat getEvenementById()", data);

    if (data == null) return null;

    return EvenementModel.fromMap(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // CRÉER UN ÉVÉNEMENT
  // ------------------------------------------------------------
  Future<void> createEvenement(EvenementModel e) async {
    _debug("createEvenement() appelé", {
      'glob_id': e.globId,
      'nom': e.nom,
      'categorie': e.categorie,
      'mot_cle1': e.motCle1,
      'mot_cle2': e.motCle2,
      'mot_cle3': e.motCle3,
      'description': e.description,
    });

    await supabase.from('evenement').insert({
      'glob_id': e.globId,
      'nom': e.nom,
      'categorie': e.categorie,
      'mot_cle1': e.motCle1,
      'mot_cle2': e.motCle2,
      'mot_cle3': e.motCle3,
      'description': e.description,
    });

    _debug("createEvenement() terminé");
  }

  // ------------------------------------------------------------
  // METTRE À JOUR UN ÉVÉNEMENT
  // ------------------------------------------------------------
  Future<void> updateEvenement(EvenementModel e) async {
    if (e.id == null) {
      _debug("updateEvenement() annulé : id == null");
      return;
    }

    _debug("updateEvenement(${e.id})", {
      'glob_id': e.globId,
      'nom': e.nom,
      'categorie': e.categorie,
      'mot_cle1': e.motCle1,
      'mot_cle2': e.motCle2,
      'mot_cle3': e.motCle3,
      'description': e.description,
    });

    await supabase
        .from('evenement')
        .update({
          'glob_id': e.globId,
          'nom': e.nom,
          'categorie': e.categorie,
          'mot_cle1': e.motCle1,
          'mot_cle2': e.motCle2,
          'mot_cle3': e.motCle3,
          'description': e.description,
        })
        .eq('id', e.id!);

    _debug("updateEvenement() terminé");
  }

  // ------------------------------------------------------------
  // SUPPRIMER UN ÉVÉNEMENT
  // ------------------------------------------------------------
  Future<void> deleteEvenement(int id) async {
    _debug("deleteEvenement($id)");

    await supabase.from('evenement').delete().eq('id', id);

    _debug("deleteEvenement() terminé");
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR TITRE (avec glob_info)
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByTitre(String nom) async {
    _debug("searchEvenementsByTitre('$nom')");

    final data = await supabase
        .from('evenement')
        .select('*, glob_info!evenement_glob_id_fkey(debut, fin, type)')
        .ilike('nom', '%$nom%')
        .order('id');

    _debug("Résultat searchEvenementsByTitre()", data);

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR CATÉGORIE (avec glob_info)
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByCategorie(int cat) async {
    _debug("searchEvenementsByCategorie($cat)");

    final data = await supabase
        .from('evenement')
        .select('*, glob_info!evenement_glob_id_fkey(debut, fin, type)')
        .eq('categorie', cat)
        .order('id');

    _debug("Résultat searchEvenementsByCategorie()", data);

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR MOTS-CLÉS (avec glob_info)
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByKeywords(String mc) async {
    _debug("searchEvenementsByKeywords('$mc')");

    final data = await supabase
        .from('evenement')
        .select('*, glob_info!evenement_glob_id_fkey(debut, fin, type)')
        .or(
          "mot_cle1.ilike('%$mc%'),mot_cle2.ilike('%$mc%'),mot_cle3.ilike('%$mc%')",
        )
        .order('id');

    _debug("Résultat searchEvenementsByKeywords()", data);

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
