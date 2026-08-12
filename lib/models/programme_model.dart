// ssc1_app/lib/models/programme_model.dart
//
// Modèle : Programme (version SSC1)
// ---------------------------------
// Correspond EXACTEMENT à la table SQL "programme".
//
// Champs SQL :
// - id
// - nom
// - desc
// - rem
// - cout
// - etablissement_id
// - glob_id
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Programme {
  final int? id;
  final String? nom;
  final String? desc;
  final String? rem;
  final double? cout;
  final int? etablissementId;
  final int? globId;

  Programme({
    this.id,
    this.nom,
    this.desc,
    this.rem,
    this.cout,
    this.etablissementId,
    this.globId,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Programme.fromJson(Map<String, dynamic> json) {
    return Programme(
      id: json['id'],
      nom: json['nom'],
      desc: json['desc'],
      rem: json['rem'],
      cout: json['cout'] != null ? (json['cout'] as num).toDouble() : null,
      etablissementId: json['etablissement_id'],
      globId: json['glob_id'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'desc': desc,
      'rem': rem,
      'cout': cout,
      'etablissement_id': etablissementId,
      'glob_id': globId,
    };
  }
}
