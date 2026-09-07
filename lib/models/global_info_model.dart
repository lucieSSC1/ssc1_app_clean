// ============================================================
// FICHIER : lib/models/global_info_model.dart
// Modèle GlobalInfo — Version SSC1 complète et compilable
// ============================================================

class GlobalInfo {
  final int? id;
  final String type;
  final DateTime? debut;
  final DateTime? fin;

  GlobalInfo({this.id, required this.type, this.debut, this.fin});

  // ------------------------------------------------------------
  // PARSE DATE
  // ------------------------------------------------------------
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  // ------------------------------------------------------------
  // fromJson — version originale
  // ------------------------------------------------------------
  factory GlobalInfo.fromJson(Map<String, dynamic> json) {
    return GlobalInfo(
      id: json['id'] as int?,
      type: json['type'] ?? "",
      debut: _parseDate(json['debut']),
      fin: _parseDate(json['fin']),
    );
  }

  // ------------------------------------------------------------
  // fromMap — version requise par les services SSC1
  // ------------------------------------------------------------
  factory GlobalInfo.fromMap(Map<String, dynamic> map) {
    final info = GlobalInfo(
      id: map['id'] as int?,
      type: map['type'] ?? "",
      debut: _parseDate(map['debut']),
      fin: _parseDate(map['fin']),
    );

    // ⭐ AJOUT : Debug complet pour voir les dates rechargées
    print("DEBUG-GLOB: fromMap() → glob_info chargé");
    print("  id: ${info.id}");
    print("  type: ${info.type}");
    print("  debut: ${info.debut}");
    print("  fin: ${info.fin}");

    return info;
  }

  // ------------------------------------------------------------
  // toJson — version originale
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'debut': debut?.toIso8601String(),
      'fin': fin?.toIso8601String(),
    };
  }
}
