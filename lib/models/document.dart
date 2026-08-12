// lib/models/document.dart

class DocumentSSC1 {
  final int id;
  final int? globId;
  final DateTime? dateSaisie;
  final String titre;

  final String? motCle1;
  final String? motCle2;
  final String? motCle3;

  final String? documentUrl;
  final String? rem;

  DocumentSSC1({
    required this.id,
    required this.globId,
    required this.dateSaisie,
    required this.titre,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.documentUrl,
    this.rem,
  });

  factory DocumentSSC1.fromJson(Map<String, dynamic> json) {
    return DocumentSSC1(
      id: json["id"],
      globId: json["glob_id"],
      dateSaisie: json["date_saisie"] != null
          ? DateTime.parse(json["date_saisie"])
          : null,
      titre: json["titre"] ?? "",
      motCle1: json["mot_cle1"],
      motCle2: json["mot_cle2"],
      motCle3: json["mot_cle3"],
      documentUrl: json["document_url"],
      rem: json["rem"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "glob_id": globId,
      "date_saisie": dateSaisie?.toIso8601String(),
      "titre": titre,
      "mot_cle1": motCle1,
      "mot_cle2": motCle2,
      "mot_cle3": motCle3,
      "document_url": documentUrl,
      "rem": rem,
    };
  }
}
