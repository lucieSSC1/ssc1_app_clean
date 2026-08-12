// ssc1_app/lib/models/film_model.dart
//
// Modèle : Film (module Loisir - SSC1)
// ------------------------------------
// Correspond EXACTEMENT à la table SQL "film".
//
// Champs SQL :
// - id
// - titre
// - description
// - acteurs
// - realisateur
// - affiche_url
// - notes

class Film {
  final int? id;
  final String? titre;
  final String? description;
  final String? acteurs;
  final String? realisateur;
  final String? afficheUrl;
  final String? notes;

  Film({
    this.id,
    this.titre,
    this.description,
    this.acteurs,
    this.realisateur,
    this.afficheUrl,
    this.notes,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      titre: json['titre'],
      description: json['description'],
      acteurs: json['acteurs'],
      realisateur: json['realisateur'],
      afficheUrl: json['affiche_url'],
      notes: json['notes'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'acteurs': acteurs,
      'realisateur': realisateur,
      'affiche_url': afficheUrl,
      'notes': notes,
    };
  }
}
