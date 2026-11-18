// ============================================================
// FICHIER : lib/services/chronologie_service.dart
// SSC1 - Générateur de chronologie
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chronologie_item.dart';
import '../models/global_info_model.dart';
import 'global_info_service.dart';

class ChronologieService {
  final supabase = Supabase.instance.client;

  final _globService = GlobalInfoService();

  Future<List<ChronologieItem>> genererChronologie({
    required DateTime debut,
    required DateTime fin,
    required List<String> types,
  }) async {
    final List<ChronologieItem> items = [];

    if (types.contains('RES')) {
      items.addAll(await _chargerResidences(debut, fin));
    }

    if (types.contains('ACQU')) {
      items.addAll(await _chargerAcquisitions(debut, fin));
    }

    if (types.contains('REF')) {
      items.addAll(await _chargerReferences(debut, fin));
    }

    if (types.contains('EVE')) {
      items.addAll(await _chargerEvenements(debut, fin));
    }

    if (types.contains('COUR')) {
      items.addAll(await _chargerCours(debut, fin));
    }

    if (types.contains('EMPL')) {
      items.addAll(await _chargerEmplois(debut, fin));
    }

    if (types.contains('LOIS')) {
      items.addAll(await _chargerLoisirs(debut, fin));
    }

    if (types.contains('PROJ')) {
      items.addAll(await _chargerProjets(debut, fin));
    }

    items.sort((a, b) => a.debut.compareTo(b.debut));

    return items;
  }

  // ==========================================================
  // OUTIL COMMUN
  // ==========================================================

  Future<ChronologieItem?> _creerItem({
    required int? globId,
    required String type,
    required String description,
    required DateTime debutRecherche,
    required DateTime finRecherche,
  }) async {
    if (globId == null) return null;

    final GlobalInfo? info = await _globService.getById(globId);

    if (info == null || info.debut == null) {
      return null;
    }

    if (info.debut!.isBefore(debutRecherche)) {
      return null;
    }

    if (info.debut!.isAfter(finRecherche)) {
      return null;
    }

    return ChronologieItem(
      debut: info.debut!,
      fin: info.fin,
      type: type,
      description: description,
    );
  }

  // ==========================================================
  // RES
  // ==========================================================

  Future<List<ChronologieItem>> _chargerResidences(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('residence').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'RES',
        description: row['ville'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // ACQU
  // ==========================================================

  Future<List<ChronologieItem>> _chargerAcquisitions(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('acquisition').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'ACQU',
        description: row['nom'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // REF
  // ==========================================================

  Future<List<ChronologieItem>> _chargerReferences(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('reference').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'REF',
        description: row['titre'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // EVE
  // ==========================================================

  Future<List<ChronologieItem>> _chargerEvenements(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('evenement').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'EVE',
        description: row['nom'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // COUR
  // ==========================================================

  Future<List<ChronologieItem>> _chargerCours(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('cours').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'COUR',
        description: row['nom'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // EMPL
  // ==========================================================

  Future<List<ChronologieItem>> _chargerEmplois(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('emploi').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'EMPL',
        description: row['fonction'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // LOIS
  // ==========================================================

  Future<List<ChronologieItem>> _chargerLoisirs(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('loisir').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'LOIS',
        description: row['titre'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }

  // ==========================================================
  // PROJ
  // ==========================================================

  Future<List<ChronologieItem>> _chargerProjets(
    DateTime debut,
    DateTime fin,
  ) async {
    final data = await supabase.from('projet').select();

    final List<ChronologieItem> resultat = [];

    for (final row in data) {
      final item = await _creerItem(
        globId: row['glob_id'],
        type: 'PROJ',
        description: row['nom'] ?? '',
        debutRecherche: debut,
        finRecherche: fin,
      );

      if (item != null) resultat.add(item);
    }

    return resultat;
  }
}
