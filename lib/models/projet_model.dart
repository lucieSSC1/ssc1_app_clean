// -----------------------------------------------------------------------------
// CHEMIN : lib/models/projet_model.dart
// -----------------------------------------------------------------------------
// Modèle PROJET (Structure 4)
// -----------------------------------------------------------------------------

class ProjetModel {
  final int id;
  final String nom;
  final String? description;
  final String? dateDebut;
  final String? dateFin;
  final double? heuresPrevues;
  final double? heuresTravaillees;

  ProjetModel({
    required this.id,
    required this.nom,
    this.description,
    this.dateDebut,
    this.dateFin,
    this.heuresPrevues,
    this.heuresTravaillees,
  });

  factory ProjetModel.fromJson(Map<String, dynamic> json) {
    return ProjetModel(
      id: json['id'] as int,
      nom: json['nom'] as String,
      description: json['description'] as String?,
      dateDebut: json['date_debut'] as String?,
      dateFin: json['date_fin'] as String?,
      heuresPrevues: json['heures_prevues'] != null
          ? (json['heures_prevues'] as num).toDouble()
          : null,
      heuresTravaillees: json['heures_travaillees'] != null
          ? (json['heures_travaillees'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'date_debut': dateDebut,
      'date_fin': dateFin,
      'heures_prevues': heuresPrevues,
      'heures_travaillees': heuresTravaillees,
    };
  }
}