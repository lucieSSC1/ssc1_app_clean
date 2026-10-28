// ============================================================
// FICHIER : lib/services/document_service.dart
// Service Document — Version SSC1
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/document_model.dart';
import '../models/global_info_model.dart';
import 'global_info_service.dart';

class DocumentService {
  final supabase = Supabase.instance.client;

  final _globService = GlobalInfoService();

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-DOC-SERVICE: $msg");

    if (data != null) {
      print("DEBUG-DATA: $data");
    }
  }

  // ------------------------------------------------------------
  // LISTER TOUS LES DOCUMENTS
  // ------------------------------------------------------------
  Future<List<DocumentModel>> getAllDocuments() async {
    _debug("getAllDocuments()");

    final data = await supabase.from('document').select('*').order('id');

    return (data as List)
        .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ------------------------------------------------------------
  // OBTENIR PAR ID
  // ------------------------------------------------------------
  Future<DocumentModel?> getDocumentById(int id) async {
    _debug("getDocumentById($id)");

    final data = await supabase
        .from('document')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;

    return DocumentModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // CRÉER
  // ------------------------------------------------------------
  Future<DocumentModel> createDocument(DocumentModel doc) async {
    _debug("createDocument()", {
      'glob_id': doc.globId,
      'date_saisie': doc.dateSaisie?.toIso8601String(),
      'titre': doc.titre,
      'mot_cle1': doc.motCle1,
      'mot_cle2': doc.motCle2,
      'mot_cle3': doc.motCle3,
      'chronique_url': doc.chroniqueUrl,
      'rem': doc.rem,
    });

    final response = await supabase
        .from('document')
        .insert({
          'glob_id': doc.globId,
          'date_saisie': doc.dateSaisie?.toIso8601String(),
          'titre': doc.titre,
          'mot_cle1': doc.motCle1,
          'mot_cle2': doc.motCle2,
          'mot_cle3': doc.motCle3,
          'chronique_url': doc.chroniqueUrl,
          'rem': doc.rem,
        })
        .select('*')
        .maybeSingle();

    if (response == null) {
      throw Exception("Erreur création document : réponse vide");
    }

    return DocumentModel.fromJson(response as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // MODIFIER
  // ------------------------------------------------------------
  Future<DocumentModel> updateDocument(DocumentModel doc) async {
    if (doc.id == null) return doc;

    _debug("updateDocument(${doc.id})");

    await supabase
        .from('document')
        .update({
          'glob_id': doc.globId,
          'date_saisie': doc.dateSaisie?.toIso8601String(),
          'titre': doc.titre,
          'mot_cle1': doc.motCle1,
          'mot_cle2': doc.motCle2,
          'mot_cle3': doc.motCle3,
          'chronique_url': doc.chroniqueUrl,
          'rem': doc.rem,
        })
        .eq('id', doc.id!);

    final data = await supabase
        .from('document')
        .select('*')
        .eq('id', doc.id!)
        .maybeSingle();

    if (data == null) {
      throw Exception("Erreur update document : GET après update vide");
    }

    return DocumentModel.fromJson(data as Map<String, dynamic>);
  }

  // ------------------------------------------------------------
  // SUPPRIMER
  // ------------------------------------------------------------
  Future<void> deleteDocument(int id) async {
    _debug("deleteDocument($id)");

    final doc = await getDocumentById(id);

    if (doc == null) return;

    final globId = doc.globId;

    await supabase.from('document').delete().eq('id', id);

    if (globId != null) {
      await supabase.from('glob_info').delete().eq('id', globId);

      _debug("glob_info supprimé", globId);
    }
  }

  // ------------------------------------------------------------
  // RECHERCHE PAR TITRE
  // ------------------------------------------------------------
  Future<List<DocumentModel>> searchDocumentsByTitre(String titre) async {
    _debug("searchDocumentsByTitre('$titre')");

    if (titre.trim().isEmpty) return [];

    final clean = _normalize(titre.trim());

    final data = await supabase.from('document').select('*').order('id');

    final all = (data as List)
        .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final filtered = all.where((doc) {
      return _normalize(doc.titre).contains(clean);
    }).toList();

    await _sortByDebut(filtered);

    return filtered;
  }

  // ------------------------------------------------------------
  // RECHERCHE MOTS-CLÉS ET / OU
  // ------------------------------------------------------------
  Future<List<DocumentModel>> searchDocumentsByKeywordsEtOu(
    String mc1,
    String mc2,
    String mc3,
    bool modeEt,
    bool rechercheExacte,
  ) async {
    final mcList = [
      _normalize(mc1.trim()),
      _normalize(mc2.trim()),
      _normalize(mc3.trim()),
    ].where((e) => e.isNotEmpty).toList();

    if (mcList.isEmpty) return [];

    final data = await supabase.from('document').select('*').order('id');

    final all = (data as List)
        .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    bool compare(String base, String mc) {
      final b = _normalize(base);

      return rechercheExacte ? b == mc : b.contains(mc);
    }

    List<DocumentModel> filtered;

    if (!modeEt) {
      filtered = all.where((doc) {
        return mcList.any(
          (mc) =>
              compare(doc.motCle1 ?? "", mc) ||
              compare(doc.motCle2 ?? "", mc) ||
              compare(doc.motCle3 ?? "", mc),
        );
      }).toList();
    } else {
      filtered = all.where((doc) {
        return mcList.every(
          (mc) =>
              compare(doc.motCle1 ?? "", mc) ||
              compare(doc.motCle2 ?? "", mc) ||
              compare(doc.motCle3 ?? "", mc),
        );
      }).toList();
    }

    await _sortByDebut(filtered);

    return filtered;
  }

  // ------------------------------------------------------------
  // TRI CHRONOLOGIQUE SUR glob_info.debut
  // ------------------------------------------------------------
  Future<void> _sortByDebut(List<DocumentModel> liste) async {
    final map = <int, DateTime?>{};

    for (var doc in liste) {
      if (doc.globId != null) {
        final info = await _globService.getById(doc.globId!);

        map[doc.id!] = info?.debut;
      } else {
        map[doc.id!] = null;
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
