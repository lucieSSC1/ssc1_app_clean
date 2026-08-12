// ssc1_app/lib/models/identite_model.dart
//
// Modèle : Identite
// ------------------
// Représente l’identité de la personne dans le module Biographie.
// Champs typiques :
// - id
// - prenom
// - nom
// - dateNaissance
// - lieuNaissance
// - nationalite
//
// Ce fichier n’existait pas dans structure 2, mais il est essentiel
// pour reconstruire SSC1 proprement.

class Identite {
  final int? id;
  final String prenom;
  final String nom;
  final DateTime? dateNaissance;
  final String? lieuNaissance;
  final String? nationalite;

  Identite({
    this.id,
    required this.prenom,
    required this.nom,
    this.dateNaissance,
    this.lieuNaissance,
    this.nationalite,
  });

  factory Identite.fromJson(Map<String, dynamic> json) {
    return Identite(
      id: json['id'],
      prenom: json['prenom'] ?? "",
      nom: json['nom'] ?? "",
      dateNaissance: json['dateNaissance'] != null
          ? DateTime.parse(json['dateNaissance'])
          : null,
      lieuNaissance: json['lieuNaissance'],
      nationalite: json['nationalite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prenom': prenom,
      'nom': nom,
      'dateNaissance': dateNaissance?.toIso8601String(),
      'lieuNaissance': lieuNaissance,
      'nationalite': nationalite,
    };
  }
}
