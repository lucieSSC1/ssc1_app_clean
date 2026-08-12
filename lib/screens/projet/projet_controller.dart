// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/projet_controller.dart
// -----------------------------------------------------------------------------
// Contrôleur principal du module Projet (Structure 4)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

class ProjetModel {
  final int id;

  String titre;
  String? debut;        // DATE (glob_info)
  String? fin;          // DATE (glob_info)

  int? categorieId;     // FK proj_categ
  int? domaineId;       // domaineId (1–5)

  String? description;
  String? objectif;
  String? notes;
  String? tag;
  String? directory;

  // Champs calculés
  double pourcentageComplete;
  double heuresTravaillees;
  double heuresTotales;

  ProjetModel({
    required this.id,
    required this.titre,
    this.debut,
    this.fin,
    this.categorieId,
    this.domaineId,
    this.description,
    this.objectif,
    this.notes,
    this.tag,
    this.directory,
    this.pourcentageComplete = 0.0,
    this.heuresTravaillees = 0.0,
    this.heuresTotales = 0.0,
  });
}

// -----------------------------------------------------------------------------
// CONTROLLER
// -----------------------------------------------------------------------------

class ProjetController extends ChangeNotifier {
  ProjetModel? _projetActif;

  ProjetModel? get projetActif => _projetActif;

  bool get aUnProjet => _projetActif != null;

  // ---------------------------------------------------------------------------
  // SÉLECTION D’UN PROJET
  // ---------------------------------------------------------------------------
  void selectionnerProjet(ProjetModel projet) {
    _projetActif = projet;
    _calculerChamps();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // CHARGEMENT (API)
  // ---------------------------------------------------------------------------
  Future<void> chargerProjetDepuisAPI(int projetId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    _projetActif = ProjetModel(
      id: projetId,
      titre: "Projet exemple",
      debut: "2025-01-01",
      fin: "2025-03-01",
      categorieId: 1,
      domaineId: 3,
      objectif: "Livrer dans les délais",
      description: "Description du projet",
      notes: "Notes internes",
      tag: "TAG",
      directory: "/projets/exemple",
    );

    _calculerChamps();
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // MISE À JOUR DES CHAMPS
  // ---------------------------------------------------------------------------

  void mettreAJourTitre(String v) {
    if (_projetActif == null) return;
    _projetActif!.titre = v;
    notifyListeners();
  }

  void mettreAJourDebut(String v) {
    if (_projetActif == null) return;
    _projetActif!.debut = v;
    notifyListeners();
  }

  void mettreAJourFin(String v) {
    if (_projetActif == null) return;
    _projetActif!.fin = v;
    notifyListeners();
  }

  void mettreAJourCategorieId(String v) {
    if (_projetActif == null) return;
    _projetActif!.categorieId = int.tryParse(v);
    notifyListeners();
  }

  void mettreAJourDomaineId(int? v) {
    if (_projetActif == null) return;
    _projetActif!.domaineId = v;
    notifyListeners();
  }

  void mettreAJourObjectif(String v) {
    if (_projetActif == null) return;
    _projetActif!.objectif = v;
    notifyListeners();
  }

  void mettreAJourDescription(String v) {
    if (_projetActif == null) return;
    _projetActif!.description = v;
    notifyListeners();
  }

  void mettreAJourNotes(String v) {
    if (_projetActif == null) return;
    _projetActif!.notes = v;
    notifyListeners();
  }

  void mettreAJourTag(String v) {
    if (_projetActif == null) return;
    _projetActif!.tag = v;
    notifyListeners();
  }

  void mettreAJourDirectory(String v) {
    if (_projetActif == null) return;
    _projetActif!.directory = v;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // CALCULS
  // ---------------------------------------------------------------------------
  void _calculerChamps() {
    if (_projetActif == null) return;

    // TODO : remplacer par tes vrais calculs
    _projetActif!.pourcentageComplete = 42.0;
    _projetActif!.heuresTravaillees = 120.0;
    _projetActif!.heuresTotales = 300.0;
  }
}