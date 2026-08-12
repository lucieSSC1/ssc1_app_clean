// ssc1_app/lib/models/etablissement_model.dart
//
// Modèle : Établissement (version SSC1)
// -------------------------------------
// Correspond EXACTEMENT à la table SQL "etablissement".
//
// Table SQL : etablissement
// - id
// - nom
// - adresse
// - ville
// - prov
// - code_postal
// - pays
// - telephone
// - fax
// - courriel
// - site_url
// - desc
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Etablissement {
  final int? id;
  final String? nom;
  final String? adresse;
  final String? ville;
  final String? prov;
  final String? codePostal;
  final String? pays;
  final String? telephone;
  final String? fax;
  final String? courriel;
  final String? siteUrl;
  final String? desc;

  Etablissement({
    this.id,
    this.nom,
    this.adresse,
    this.ville,
    this.prov,
    this.codePostal,
    this.pays,
    this.telephone,
    this.fax,
    this.courriel,
    this.siteUrl,
    this.desc,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Etablissement.fromJson(Map<String, dynamic> json) {
    return Etablissement(
      id: json['id'],
      nom: json['nom'],
      adresse: json['adresse'],
      ville: json['ville'],
      prov: json['prov'],
      codePostal: json['code_postal'],
      pays: json['pays'],
      telephone: json['telephone'],
      fax: json['fax'],
      courriel: json['courriel'],
      siteUrl: json['site_url'],
      desc: json['desc'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'adresse': adresse,
      'ville': ville,
      'prov': prov,
      'code_postal': codePostal,
      'pays': pays,
      'telephone': telephone,
      'fax': fax,
      'courriel': courriel,
      'site_url': siteUrl,
      'desc': desc,
    };
  }
}