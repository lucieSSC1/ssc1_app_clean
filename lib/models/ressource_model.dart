// -----------------------------------------------------------------------------
// CHEMIN : lib/models/ressource_model.dart
// -----------------------------------------------------------------------------
// Modèle pour la table ressource (Structure 2)
// -----------------------------------------------------------------------------

class RessourceModel {
  final int id;
  final String nom;
  final String? compagnie;
  final double? tauxHoraire;
  final String? telephone;
  final String? fax;
  final String? courriel;
  final String? adresse;
  final String? ville;
  final String? codePostal;
  final String? description;
  final String? services;
  final String? note;

  RessourceModel({
    required this.id,
    required this.nom,
    this.compagnie,
    this.tauxHoraire,
    this.telephone,
    this.fax,
    this.courriel,
    this.adresse,
    this.ville,
    this.codePostal,
    this.description,
    this.services,
    this.note,
  });

  factory RessourceModel.fromJson(Map<String, dynamic> json) {
    return RessourceModel(
      id: json['id'],
      nom: json['nom'],
      compagnie: json['compagnie'],
      tauxHoraire: json['taux_horaire']?.toDouble(),
      telephone: json['telephone'],
      fax: json['fax'],
      courriel: json['courriel'],
      adresse: json['adresse'],
      ville: json['ville'],
      codePostal: json['code_postal'],
      description: json['description'],
      services: json['services'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'compagnie': compagnie,
      'taux_horaire': tauxHoraire,
      'telephone': telephone,
      'fax': fax,
      'courriel': courriel,
      'adresse': adresse,
      'ville': ville,
      'code_postal': codePostal,
      'description': description,
      'services': services,
      'note': note,
    };
  }
}