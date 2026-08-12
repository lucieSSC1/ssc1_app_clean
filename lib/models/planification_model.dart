/* -----------------------------------------------------------------------------
   FICHIER : lib/models/planification_model.dart
   STRUCTURE 4 — Modèle Planification

   Une planification est une activité mise dans la liste de travail.
   Elle contient :
     - l'identité de l'activité (id, code, nom)
     - une description optionnelle
     - un statut "terminée"
     - un lien vers l'activité (activ_id)
   ----------------------------------------------------------------------------- */

class PlanificationModel {
  final int id;
  final int activId;

  final String activCode;
  final String activNom;

  String? description;
  bool terminee;

  PlanificationModel({
    required this.id,
    required this.activId,
    required this.activCode,
    required this.activNom,
    this.description,
    this.terminee = false,
  });

  // ---------------------------------------------------------------------------
  // FROM JSON
  // ---------------------------------------------------------------------------
  factory PlanificationModel.fromJson(Map<String, dynamic> json) {
    return PlanificationModel(
      id: json['id'],
      activId: json['activ_id'],
      activCode: json['activ_code'],
      activNom: json['activ_nom'],
      description: json['description'],
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
      'description': description,
      'terminee': terminee,
    };
  }
}