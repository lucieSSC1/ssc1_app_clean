/* ---------------------------------------------------------------------------
   CHEMIN : lib/models/lot_model.dart
   DESCRIPTION : Modèle LOT (Structure 4)
   --------------------------------------------------------------------------- */

class LotModel {
  final int id;
  final String? code;
  final String? nom;
  final String? description;
  final bool statut;
  final int? projId;

  LotModel({
    required this.id,
    this.code,
    this.nom,
    this.description,
    this.statut = false,
    this.projId,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      nom: json['nom'] as String?,
      description: json['description'] as String?,
      statut: json['statut'] == true,
      projId: json['proj_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'description': description,
      'statut': statut,
      'proj_id': projId,
    };
  }
}