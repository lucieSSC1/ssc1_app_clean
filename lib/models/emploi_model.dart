// ssc1_app/lib/models/emploi_model.dart
//
// Modèle : Emploi (version SSC1)
// ------------------------------
// Correspond EXACTEMENT à la table SQL "emploi".
//
// Champs SQL :
// - id
// - glob_id
// - fonction
// - employeur_id
// - taches
// - no_contrat
// - taux_horaire
// - commentaire
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Emploi {
  final int? id;
  final int? globId;
  final String? fonction;
  final int? employeurId;
  final String? taches;
  final String? noContrat;
  final double? tauxHoraire;
  final String? commentaire;

  Emploi({
    this.id,
    this.globId,
    this.fonction,
    this.employeurId,
    this.taches,
    this.noContrat,
    this.tauxHoraire,
    this.commentaire,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Emploi.fromJson(Map<String, dynamic> json) {
    return Emploi(
      id: json['id'],
      globId: json['glob_id'],
      fonction: json['fonction'],
      employeurId: json['employeur_id'],
      taches: json['taches'],
      noContrat: json['no_contrat'],
      tauxHoraire: json['taux_horaire'] != null
          ? (json['taux_horaire'] as num).toDouble()
          : null,
      commentaire: json['commentaire'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'glob_id': globId,
      'fonction': fonction,
      'employeur_id': employeurId,
      'taches': taches,
      'no_contrat': noContrat,
      'taux_horaire': tauxHoraire,
      'commentaire': commentaire,
    };
  }
}
