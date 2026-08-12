// ssc1_app/lib/models/global_info_model.dart
//
// Mod�le : GlobalInfo
// --------------------
// Champs :
// - id
// - type
// - debut
// - fin

class GlobalInfo {
  final int? id;
  final String type;
  final DateTime? debut;
  final DateTime? fin;

  GlobalInfo({this.id, required this.type, this.debut, this.fin});

  factory GlobalInfo.fromJson(Map<String, dynamic> json) {
    return GlobalInfo(
      id: json['id'],
      type: json['type'] ?? "",
      debut: json['debut'] != null ? DateTime.parse(json['debut']) : null,
      fin: json['fin'] != null ? DateTime.parse(json['fin']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'debut': debut?.toIso8601String(),
      'fin': fin?.toIso8601String(),
    };
  }
}
