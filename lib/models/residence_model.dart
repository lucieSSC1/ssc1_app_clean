// ssc1_app/lib/models/residence_model.dart
//
// Modèle : Residence (version SSC1)
// ---------------------------------
// Représente une résidence dans le module Biographie.
// Basé sur la table SQL residence + les champs fonctionnels.
//
// Champs :
// - id
// - globId (référence vers global_info.id)
// - adresse (numéro civique + rue)
// - ville
// - province
// - pays
// - commentaire (rem dans SQL)
// - loyer (REAL)
//
// Note : Il n’y a PAS de champ "type" dans la table SQL.

class Residence {
  final int? id;
  final int? globId;
  final String adresse;
  final String ville;
  final String province;
  final String pays;
  final String? commentaire;
  final double? loyer;

  Residence({
    this.id,
    this.globId,
    required this.adresse,
    required this.ville,
    required this.province,
    required this.pays,
    this.commentaire,
    this.loyer,
  });

  factory Residence.fromJson(Map<String, dynamic> json) {
    return Residence(
      id: json['id'],
      globId: json['globId'],
      adresse: json['adresse'] ?? "",
      ville: json['ville'] ?? "",
      province: json['province'] ?? "",
      pays: json['pays'] ?? "",
      commentaire: json['commentaire'],
      loyer: json['loyer'] != null ? (json['loyer'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'globId': globId,
      'adresse': adresse,
      'ville': ville,
      'province': province,
      'pays': pays,
      'commentaire': commentaire,
      'loyer': loyer,
    };
  }
}
