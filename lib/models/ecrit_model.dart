// ssc1_app/lib/models/ecrit_model.dart
//
// Modèle : Écrit (module Loisir - SSC1)
// -------------------------------------
// Correspond EXACTEMENT à la table SQL "ecrit".
//
// Champs SQL :
// - id
// - titre
// - type
// - auteur
// - texte_url
// - notes

class Ecrit {
  final int? id;
  final String? titre;
  final String? type;
  final String? auteur;
  final String? texteUrl;
  final String? notes;

  Ecrit({
    this.id,
    this.titre,
    this.type,
    this.auteur,
    this.texteUrl,
    this.notes,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Ecrit.fromJson(Map<String, dynamic> json) {
    return Ecrit(
      id: json['id'],
      titre: json['titre'],
      type: json['type'],
      auteur: json['auteur'],
      texteUrl: json['texte_url'],
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
      'type': type,
      'auteur': auteur,
      'texte_url': texteUrl,
      'notes': notes,
    };
  }
}