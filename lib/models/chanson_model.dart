// ssc1_app/lib/models/chanson_model.dart
//
// Modèle : Chanson (module Loisir - SSC1)
// ---------------------------------------
// Correspond EXACTEMENT à la table SQL "chanson".
//
// Champs SQL :
// - id
// - titre
// - auteur
// - compositeur
// - interprete
// - paroles_url
// - notes

class Chanson {
  final int? id;
  final String? titre;
  final String? auteur;
  final String? compositeur;
  final String? interprete;
  final String? parolesUrl;
  final String? notes;

  Chanson({
    this.id,
    this.titre,
    this.auteur,
    this.compositeur,
    this.interprete,
    this.parolesUrl,
    this.notes,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Chanson.fromJson(Map<String, dynamic> json) {
    return Chanson(
      id: json['id'],
      titre: json['titre'],
      auteur: json['auteur'],
      compositeur: json['compositeur'],
      interprete: json['interprete'],
      parolesUrl: json['paroles_url'],
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
      'auteur': auteur,
      'compositeur': compositeur,
      'interprete': interprete,
      'paroles_url': parolesUrl,
      'notes': notes,
    };
  }
}