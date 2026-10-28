// lib/models/maintenance_model.dart
//
// Modèle : Maintenance (version SSC1)
// -----------------------------------
// Table maintenance
//
// id
// acqu_id
// date
// a_effectuer
// reparateur
// effectue
// duree
// pieces
// cout
// facture
// -----------------------------------

class MaintenanceModel {
  final int? id;

  // FK vers acquisition.id
  final int acquId;

  final DateTime date;

  final String? aEffectuer;
  final String? reparateur;
  final String? effectue;

  final double? duree;
  final double? pieces;
  final double? cout;

  final String? facture;

  MaintenanceModel({
    this.id,
    required this.acquId,
    required this.date,
    this.aEffectuer,
    this.reparateur,
    this.effectue,
    this.duree,
    this.pieces,
    this.cout,
    this.facture,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      acquId: json['acqu_id'],

      date: DateTime.parse(json['date']),

      aEffectuer: json['a_effectuer'],
      reparateur: json['reparateur'],
      effectue: json['effectue'],

      duree: json['duree'] != null ? (json['duree'] as num).toDouble() : null,

      pieces: json['pieces'] != null
          ? (json['pieces'] as num).toDouble()
          : null,

      cout: json['cout'] != null ? (json['cout'] as num).toDouble() : null,

      facture: json['facture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'acqu_id': acquId,
      'date': date.toIso8601String(),

      'a_effectuer': aEffectuer,
      'reparateur': reparateur,
      'effectue': effectue,

      'duree': duree,
      'pieces': pieces,
      'cout': cout,

      'facture': facture,
    };
  }
}
