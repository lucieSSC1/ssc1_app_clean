// ssc1_app/lib/models/recette_model.dart
//
// Modèle : Recette (module Loisir - SSC1)
// ---------------------------------------
// Correspond EXACTEMENT à la table SQL "recette".
//
// Champs SQL :
// - id
// - nom
// - categorie   (ENUM : soupe, entrée, plat principal, dessert, collation, boisson)
// - source
// - recette_url
// - notes

class Recette {
  final int? id;
  final String? nom;
  final String? categorie;
  final String? source;
  final String? recetteUrl;
  final String? notes;

  Recette({
    this.id,
    this.nom,
    this.categorie,
    this.source,
    this.recetteUrl,
    this.notes,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Recette.fromJson(Map<String, dynamic> json) {
    return Recette(
      id: json['id'],
      nom: json['nom'],
      categorie: json['categorie'],
      source: json['source'],
      recetteUrl: json['recette_url'],
      notes: json['notes'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'categorie': categorie,
      'source': source,
      'recette_url': recetteUrl,
      'notes': notes,
    };
  }
}