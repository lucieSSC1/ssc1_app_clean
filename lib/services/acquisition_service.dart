// ssc1_app/lib/services/acquisition_service.dart
//
// Service : Acquisition (version SSC1)
// ------------------------------------
// CRUD complet + recherche par titre + tri chronologique via glob_info
// Table acquisition : id, glob_id, nom, description, vendeur_id, garantie,
// expire, prix, commentaire, image, facture
// Table glob_info : id, debut, fin, type
// ----------------------------------------------

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/acquisition_model.dart';
import '../models/global_info_model.dart';
import 'global_info_service.dart';

class AcquisitionService {
  final supabase = Supabase.instance.client;
  final _globService = GlobalInfoService();

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-ACQ-SERVICE: $msg");
    if (data != null) print("DEBUG-DATA: $data");
  }

  // ------------------------------------------------------------
  // LISTER TOUTES LES ACQUISITIONS
  // ------------------------------------------------------------
  Future<List<AcquisitionModel>> getAllAcquisitions() async {
    _debug("getAllAcquisitions()");

    final data = await supabase.from('acquisition').select('*').order('id');

    return (data as List)
        .map((e) => AcquisitionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // OBTENIR PAR ID
  // ------------------------------------------------------------
  Future<AcquisitionModel?> getAcquisitionById(int id) async {
    _debug("getAcquisitionById($id)");

    final data = await supabase
        .from('acquisition')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;

    return AcquisitionModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // CRÉER
  // ------------------------------------------------------------
  Future<AcquisitionModel> createAcquisition(AcquisitionModel a) async {
    _debug("createAcquisition()", a.toJson());

    final response = await supabase
        .from('acquisition')
        .insert(a.toJson())
        .select('*')
        .maybeSingle();

    if (response == null) {
      throw Exception("Erreur création acquisition : réponse vide");
    }

    return AcquisitionModel.fromJson(response as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // METTRE À JOUR
  // ------------------------------------------------------------
  Future<AcquisitionModel> updateAcquisition(AcquisitionModel a) async {
    if (a.id == null) return a;

    _debug("updateAcquisition(${a.id})");

    await supabase.from('acquisition').update(a.toJson()).eq('id', a.id!);

    final data = await supabase
        .from('acquisition')
        .select('*')
        .eq('id', a.id!)
        .maybeSingle();

    if (data == null) {
      throw Exception("Erreur update acquisition : GET après update vide");
    }

    return AcquisitionModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // SUPPRIMER + CASCADE glob_info
  // ------------------------------------------------------------
  Future<void> deleteAcquisition(int id) async {
    _debug("deleteAcquisition($id)");

    final acq = await getAcquisitionById(id);
    if (acq == null) return;

    final globId = acq.globId;

    await supabase.from('acquisition').delete().eq('id', id);

    if (globId != null) {
      await supabase.from('glob_info').delete().eq('id', globId);
      _debug("glob_info supprimé", globId);
    }
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR TITRE + TRI CHRONOLOGIQUE
  // ------------------------------------------------------------
  Future<List<AcquisitionModel>> searchAcquisitionsByTitre(String nom) async {
    _debug("searchAcquisitionsByTitre('$nom')");

    if (nom.trim().isEmpty) return [];

    final clean = _normalize(nom.trim());

    final data = await supabase.from('acquisition').select('*').order('id');

    final all = (data as List)
        .map((e) => AcquisitionModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final filtered = all.where((acq) {
      final acqNom = _normalize(acq.nom);
      return acqNom.contains(clean);
    }).toList();

    await _sortByDebut(filtered);

    return filtered;
  }

  // ------------------------------------------------------------
  // TRI CHRONOLOGIQUE via glob_info
  // ------------------------------------------------------------
  Future<void> _sortByDebut(List<AcquisitionModel> liste) async {
    final map = <int, DateTime?>{};

    for (var acq in liste) {
      if (acq.globId != null) {
        final info = await _globService.getById(acq.globId!);
        map[acq.id!] = info?.debut;
      } else {
        map[acq.id!] = null;
      }
    }

    liste.sort((a, b) {
      final da = map[a.id] ?? DateTime(1900);
      final db = map[b.id] ?? DateTime(1900);
      return da.compareTo(db);
    });
  }

  // ------------------------------------------------------------
  // NORMALISATION
  // ------------------------------------------------------------
  String _normalize(String s) {
    final map = {
      'à': 'a',
      'â': 'a',
      'ä': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'î': 'i',
      'ï': 'i',
      'ô': 'o',
      'ö': 'o',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ÿ': 'y',
    };

    return s.toLowerCase().split('').map((c) => map[c] ?? c).join();
  }
}
