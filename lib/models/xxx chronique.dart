// lib/models/chronique.dart

class Chronique {
  final int id;
  final int? globId;          // lien vers global_info
  final DateTime? dateSaisie;
  final String titre;

  final String? motCle1;
  final String? motCle2;
  final String? motCle3;

  final String? chroniqueUrl; // lien Cloud (Supabase Storage)
  final String? rem;          // remarque / notes

  Chronique({
    required this.id,
    required this.globId,
    required this.dateSaisie,
    required this.titre,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.chroniqueUrl,
    this.rem,
  });

  // --------------------------------------------------------------
  // Conversion JSON ? Chronique
  // --------------------------------------------------------------
  factory Chronique.fromJson(Map<String, dynamic> json) {
    return Chronique(
      id: json["id"],
      globId: json["glob_id"],
      dateSaisie: json["date_saisie"] != null
          ? DateTime.parse(json["date_saisie"])
          : null,
      titre: json["titre"] ?? "",
      motCle1: json["mot_cle1"],
      motCle2: json["mot_cle2"],
      motCle3: json["mot_cle3"],
      chroniqueUrl: json["chronique_url"],
      rem: json["rem"],
    );
  }

  // --------------------------------------------------------------
  // Conversion Chronique ? JSON
  // --------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "glob_id": globId,
      "date_saisie": dateSaisie?.toIso8601String(),
      "titre": titre,
      "mot_cle1": motCle1,
      "mot_cle2": motCle2,
      "mot_cle3": motCle3,
      "chronique_url": chroniqueUrl,
      "rem": rem,
    };
  }
}