/* ---------------------------------------------------------------------------
   CHEMIN : lib/models/tache_model.dart
   DESCRIPTION : Modèle TÂCHE (Structure 4)
   --------------------------------------------------------------------------- */

class TacheModel {
  final int id;
  final String? code;
  final String? nom;
  final String? description;
  final bool statut;
  final int? lotId;

  TacheModel({
    required this.id,
    this.code,
    this.nom,
    this.description,
    this.statut = false,
    this.lotId,
  });

  factory TacheModel.fromJson(Map<String, dynamic> json) {
    return TacheModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      nom: json['nom'] as String?,
      description: json['description'] as String?,
      statut: json['statut'] == true,
      lotId: json['lot_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'description': description,
      'statut': statut,
      'lot_id': lotId,
    };
  }
}