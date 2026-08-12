// ssc1_app/lib/models/acquisition_model.dart
//
// Mod�le : Acquisition (version SSC1)
// ------------------------------------
// Repr�sente une acquisition personnelle dans le module Biographie.
// Champs h�rit�s de structure 2, modernis�s et normalis�s.
//
// Champs :
// - id
// - globId (r�f�rence vers GlobalInfo)
// - nom
// - description
// - vendeurId
// - garantie
// - expire
// - prix
// - commentaire
// - image
// - facture

class Acquisition {
  final int? id;
  final int? globId;
  final String nom;
  final String? description;
  final int? vendeurId;
  final String? garantie;
  final DateTime? expire;
  final double? prix;
  final String? commentaire;
  final String? image;
  final String? facture;

  Acquisition({
    this.id,
    this.globId,
    required this.nom,
    this.description,
    this.vendeurId,
    this.garantie,
    this.expire,
    this.prix,
    this.commentaire,
    this.image,
    this.facture,
  });

  factory Acquisition.fromJson(Map<String, dynamic> json) {
    return Acquisition(
      id: json['id'],
      globId: json['globId'],
      nom: json['nom'] ?? "",
      description: json['description'],
      vendeurId: json['vendeur_id'],
      garantie: json['garantie'],
      expire: json['expire'] != null ? DateTime.parse(json['expire']) : null,
      prix: json['prix'] != null ? (json['prix'] as num).toDouble() : null,
      commentaire: json['commentaire'],
      image: json['image'],
      facture: json['facture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'globId': globId,
      'nom': nom,
      'description': description,
      'vendeur_id': vendeurId,
      'garantie': garantie,
      'expire': expire?.toIso8601String(),
      'prix': prix,
      'commentaire': commentaire,
      'image': image,
      'facture': facture,
    };
  }
}
