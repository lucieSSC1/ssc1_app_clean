/* ---------------------------------------------------------------------------
   CHEMIN : lib/models/activite_model.dart
   DESCRIPTION : Modèle ACTIVITÉ (Structure 4)
   --------------------------------------------------------------------------- */

class ActiviteModel {
  final int id;
  final String? code;
  final String? nom;
  final String? description;
  final double? duree;     // heures planifiées
  final int? tacheId;

  ActiviteModel({
    required this.id,
    this.code,
    this.nom,
    this.description,
    this.duree,
    this.tacheId,
  });

  factory ActiviteModel.fromJson(Map<String, dynamic> json) {
    return ActiviteModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      nom: json['nom'] as String?,
      description: json['description'] as String?,
      duree: json['duree'] != null ? (json['duree'] as num).toDouble() : null,
      tacheId: json['tache_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'description': description,
      'duree': duree,
      'tache_id': tacheId,
    };
  }
}