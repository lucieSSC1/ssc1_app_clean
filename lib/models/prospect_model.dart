// ssc1_app/lib/models/prospect_model.dart
//
// Modèle : Prospect (version SSC1)
// --------------------------------
// Correspond EXACTEMENT à la table SQL "prospect".
//
// Champs SQL :
// - id
// - nom
// - entreprise
// - telephone
// - courriel
// - site_url
// - adresse
// - ville
// - prov
// - pays
// - commentaire
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Prospect {
  final int? id;
  final String? nom;
  final String? entreprise;
  final String? telephone;
  final String? courriel;
  final String? siteUrl;
  final String? adresse;
  final String? ville;
  final String? prov;
  final String? pays;
  final String? commentaire;

  Prospect({
    this.id,
    this.nom,
    this.entreprise,
    this.telephone,
    this.courriel,
    this.siteUrl,
    this.adresse,
    this.ville,
    this.prov,
    this.pays,
    this.commentaire,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Prospect.fromJson(Map<String, dynamic> json) {
    return Prospect(
      id: json['id'],
      nom: json['nom'],
      entreprise: json['entreprise'],
      telephone: json['telephone'],
      courriel: json['courriel'],
      siteUrl: json['site_url'],
      adresse: json['adresse'],
      ville: json['ville'],
      prov: json['prov'],
      pays: json['pays'],
      commentaire: json['commentaire'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'entreprise': entreprise,
      'telephone': telephone,
      'courriel': courriel,
      'site_url': siteUrl,
      'adresse': adresse,
      'ville': ville,
      'prov': prov,
      'pays': pays,
      'commentaire': commentaire,
    };
  }
}
