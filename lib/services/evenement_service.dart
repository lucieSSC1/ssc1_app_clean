// ============================================================
// FICHIER : lib/services/evenement_service.dart
// Service Événement — Version SSC1 stable (sans JOIN glob_info)
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
  // LISTER TOUS LES ÉVÉNEMENTS (sans JOIN)
  // ------------------------------------------------------------
  Future<List<EvenementModel>> getAllEvenements() async {
    _debug("getAllEvenements()");

    final data = await supabase.from('evenement').select('*').order('id');

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // OBTENIR PAR ID (sans JOIN)
  // ------------------------------------------------------------
  Future<EvenementModel?> getEvenementById(int id) async {
    _debug("getEvenementById($id)");

    final data = await supabase
        .from('evenement')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;

    return EvenementModel.fromMap(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // CRÉER
  // ------------------------------------------------------------
  Future<EvenementModel> createEvenement(EvenementModel e) async {
    _debug("createEvenement()", {
      'glob_id': e.globId,
      'nom': e.nom,
      'categorie': e.categorie,
      'mot_cle1': e.motCle1,
      'mot_cle2': e.motCle2,
      'mot_cle3': e.motCle3,
      'description': e.description,
    });

    final response = await supabase
        .from('evenement')
        .insert({
          'glob_id': e.globId,
          'nom': e.nom,
          'categorie': e.categorie,
          'mot_cle1': e.motCle1,
          'mot_cle2': e.motCle2,
          'mot_cle3': e.motCle3,
          'description': e.description,
        })
        .select('*')
        .maybeSingle();

    if (response == null) {
      throw Exception("Erreur création événement : réponse vide");
    }

    return EvenementModel.fromMap(response as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // METTRE À JOUR — VERSION STABLE
  // ------------------------------------------------------------
  Future<EvenementModel> updateEvenement(EvenementModel e) async {
    if (e.id == null) return e;

    _debug("updateEvenement(${e.id})");

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

    final data = await supabase
        .from('evenement')
        .select('*')
        .eq('id', e.id!)
        .maybeSingle();

    if (data == null) {
      throw Exception("Erreur update événement : GET après update vide");
    }

    return EvenementModel.fromMap(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // SUPPRIMER — CASCADE SSC1
  // ------------------------------------------------------------
  Future<void> deleteEvenement(int id) async {
    _debug("deleteEvenement($id)");

    final evt = await getEvenementById(id);
    if (evt == null) return;

    final globId = evt.globId;

    await supabase.from('evenement').delete().eq('id', id);

    if (globId != null) {
      await supabase.from('glob_info').delete().eq('id', globId);
      _debug("glob_info supprimé", globId);
    }
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR TITRE
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByTitre(String nom) async {
    _debug("searchEvenementsByTitre('$nom')");

    if (nom.trim().isEmpty) return [];

    final clean = _normalize(nom.trim());

    final data = await supabase.from('evenement').select('*').order('id');

    final all = (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return all.where((evt) {
      final evtNom = _normalize(evt.nom);
      return evtNom.contains(clean);
    }).toList();
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR CATÉGORIE
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByCategorie(int cat) async {
    _debug("searchEvenementsByCategorie($cat)");

    final data = await supabase
        .from('evenement')
        .select('*')
        .eq('categorie', cat)
        .order('id');

    return (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR MOTS-CLÉS — MODE ET / OU
  // ------------------------------------------------------------
  Future<List<EvenementModel>> searchEvenementsByKeywordsEtOu(
    String mc1,
    String mc2,
    String mc3,
    bool modeEt,
    bool rechercheExacte,
  ) async {
    _debug("searchEvenementsByKeywordsEtOu()", {
      'mc1': mc1,
      'mc2': mc2,
      'mc3': mc3,
      'modeEt': modeEt,
      'exact': rechercheExacte,
    });

    final mcList = [
      _normalize(mc1.trim()),
      _normalize(mc2.trim()),
      _normalize(mc3.trim()),
    ].where((e) => e.isNotEmpty).toList();

    if (mcList.isEmpty) return [];

    final data = await supabase.from('evenement').select('*').order('id');

    final all = (data as List)
        .map((e) => EvenementModel.fromMap(e as Map<String, dynamic>))
        .toList();

    bool compare(String base, String mc) {
      final b = _normalize(base);
      return rechercheExacte ? b == mc : b.contains(mc);
    }

    if (!modeEt) {
      return all.where((evt) {
        return mcList.any(
          (mc) =>
              compare(evt.motCle1 ?? "", mc) ||
              compare(evt.motCle2 ?? "", mc) ||
              compare(evt.motCle3 ?? "", mc),
        );
      }).toList();
    } else {
      return all.where((evt) {
        return mcList.every(
          (mc) =>
              compare(evt.motCle1 ?? "", mc) ||
              compare(evt.motCle2 ?? "", mc) ||
              compare(evt.motCle3 ?? "", mc),
        );
      }).toList();
    }
  }

  // ------------------------------------------------------------
  // NORMALISATION
  // ------------------------------------------------------------
  String _normalize(String s) {
    final map = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'á': 'a',
      'ã': 'a',
      'å': 'a',
      'ç': 'c',
      'è': 'e',
      'é': 'e',
      'ê': 'e',
      'ë': 'e',
      'ì': 'i',
      'í': 'i',
      'î': 'i',
      'ï': 'i',
      'ò': 'o',
      'ó': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ù': 'u',
      'ú': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
    };

    return s.toLowerCase().split('').map((c) => map[c] ?? c).join();
  }
}
