// -----------------------------------------------------------------------------
// CHEMIN : lib/models/proj_info_model.dart
// -----------------------------------------------------------------------------
// Modèle pour la table proj_info
// -----------------------------------------------------------------------------

class ProjInfoModel {
  final int id;
  final int projetId;
  final String texte;

  ProjInfoModel({
    required this.id,
    required this.projetId,
    required this.texte,
  });

  factory ProjInfoModel.fromJson(Map<String, dynamic> json) {
    return ProjInfoModel(
      id: json['id'],
      projetId: json['projet_id'],
      texte: json['texte'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projet_id': projetId,
      'texte': texte,
    };
  }
}
