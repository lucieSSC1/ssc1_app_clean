// lib/models/vendeur_model.dart

class Vendeur {
  final int? id;
  final String nom;
  final String? adresse;
  final String? ville;
  final String? prov;
  final String? codePostal;
  final String? pays;
  final String? telephone;
  final String? fax;
  final String? courriel;
  final String? siteUrl;

  Vendeur({
    this.id,
    required this.nom,
    this.adresse,
    this.ville,
    this.prov,
    this.codePostal,
    this.pays,
    this.telephone,
    this.fax,
    this.courriel,
    this.siteUrl,
  });

  factory Vendeur.fromJson(Map<String, dynamic> json) {
    return Vendeur(
      id: json['id'],
      nom: json['nom'] ?? "",
      adresse: json['adresse'],
      ville: json['ville'],
      prov: json['prov'],
      codePostal: json['code_postal'],
      pays: json['pays'],
      telephone: json['telephone'],
      fax: json['fax'],
      courriel: json['courriel'],
      siteUrl: json['site_url'],
    );
  }

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
    };
  }
}
