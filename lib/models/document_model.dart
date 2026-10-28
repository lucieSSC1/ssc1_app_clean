// ============================================================
// FICHIER : lib/models/document_model.dart
//
// Modèle : Document (SSC1)
// ------------------------------------------------------------
// Table : document
//
// id
// glob_id
//
// date_saisie
// titre
//
// mot_cle1
// mot_cle2
// mot_cle3
//
// chronique_url
// rem
// ============================================================

class DocumentModel {
  final int? id;

  // FK vers glob_info.id
  final int? globId;

  final DateTime? dateSaisie;

  final String titre;

  final String? motCle1;
  final String? motCle2;
  final String? motCle3;

  final String? chroniqueUrl;

  final String? rem;

  DocumentModel({
    this.id,
    this.globId,
    this.dateSaisie,
    required this.titre,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.chroniqueUrl,
    this.rem,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],

      globId: json['glob_id'],

      dateSaisie: json['date_saisie'] != null
          ? DateTime.parse(json['date_saisie'])
          : null,

      titre: json['titre'] ?? '',

      motCle1: json['mot_cle1'],
      motCle2: json['mot_cle2'],
      motCle3: json['mot_cle3'],

      chroniqueUrl: json['chronique_url'],

      rem: json['rem'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'glob_id': globId,

      'date_saisie': dateSaisie?.toIso8601String(),

      'titre': titre,

      'mot_cle1': motCle1,
      'mot_cle2': motCle2,
      'mot_cle3': motCle3,

      'chronique_url': chroniqueUrl,

      'rem': rem,
    };
  }

  DocumentModel copyWith({
    int? id,
    int? globId,
    DateTime? dateSaisie,
    String? titre,
    String? motCle1,
    String? motCle2,
    String? motCle3,
    String? chroniqueUrl,
    String? rem,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      globId: globId ?? this.globId,
      dateSaisie: dateSaisie ?? this.dateSaisie,
      titre: titre ?? this.titre,
      motCle1: motCle1 ?? this.motCle1,
      motCle2: motCle2 ?? this.motCle2,
      motCle3: motCle3 ?? this.motCle3,
      chroniqueUrl: chroniqueUrl ?? this.chroniqueUrl,
      rem: rem ?? this.rem,
    );
  }
}
