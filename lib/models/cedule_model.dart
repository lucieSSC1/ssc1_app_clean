/* -----------------------------------------------------------------------------
   FICHIER : lib/models/cedule_model.dart
   STRUCTURE 4 — Modèle CÉDULE

   Une cédule représente un engagement réel :
     - activité (id, code, nom)
     - date (DD-MM-YYYY)
     - durée planifiée (ex: "1.5")
     - statut "terminée"
   ----------------------------------------------------------------------------- */

class CeduleModel {
  final int id;
  final int activId;

  final String activCode;
  final String activNom;

  final String date;            // format : DD-MM-YYYY
  final String dureePlanifiee;  // ex: "1.5"

  bool terminee;

  CeduleModel({
    required this.id,
    required this.activId,
    required this.activCode,
    required this.activNom,
    required this.date,
    required this.dureePlanifiee,
    this.terminee = false,
  });

  // ---------------------------------------------------------------------------
  // FROM JSON
  // ---------------------------------------------------------------------------
  factory CeduleModel.fromJson(Map<String, dynamic> json) {
    return CeduleModel(
      id: json['id'],
      activId: json['activ_id'],
      activCode: json['activ_code'],
      activNom: json['activ_nom'],
      date: json['date'],
      dureePlanifiee: json['duree_planifiee'],
      terminee: json['terminee'] ?? false,
    );
  }

  // ---------------------------------------------------------------------------
  // TO JSON
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activ_id': activId,
      'activ_code': activCode,
      'activ_nom': activNom,
      'date': date,
      'duree_planifiee': dureePlanifiee,
      'terminee': terminee,
    };
  }
}
