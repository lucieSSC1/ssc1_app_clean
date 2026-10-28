class AcquisitionModel {
  final int? id; // PK auto-généré
  final int? globId; // FK vers glob_info.id
  final String nom;
  final String? description;
  final int? vendeurId;
  final String? garantie;
  final DateTime? expire;
  final double? prix;
  final String? commentaire;
  final String? image;
  final String? facture;

  AcquisitionModel({
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

  factory AcquisitionModel.fromJson(Map<String, dynamic> json) {
    return AcquisitionModel(
      id: json['id'],
      globId: json['glob_id'],
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
      'glob_id': globId,
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
