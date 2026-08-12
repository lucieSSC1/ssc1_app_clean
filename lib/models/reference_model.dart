// ssc1_app/lib/models/reference_model.dart
//
// Modèle : Reference (version SSC1)
// ---------------------------------
// Représente une ressource documentaire : livre, DVD, audio, vidéo,
// article, document, etc.
//
// Ce modèle correspond EXACTEMENT à la table SQL "reference".
// Tous les champs sont inclus, même ceux spécifiques à certains types.
//
// Table SQL : reference
// - id
// - glob_id
// - type
// - categorie_id
// - titre
// - auteur
// - date
// - domaine
// - categ
// - desc
// - location
// - collection
// - source
// - section
// - page
// - txt_section
// - pdf
// - format
// - medium
// - ISBN
// - editeur_nom
// - editeur_lieu
// - copyright
// - pages
// - prix
// - programme_id
// - projet_id
// - statut
// - commentaire
// - info
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Reference {
  final int? id;
  final int? globId;

  final String? type;
  final int? categorieId;

  final String? titre;
  final String? auteur;
  final DateTime? date;

  final String? domaine;
  final String? categ;
  final String? desc;
  final String? location;
  final String? collection;

  final String? source;
  final String? section;
  final String? page;
  final String? txtSection;

  final String? pdf;
  final String? format;
  final String? medium;

  final String? isbn;
  final String? editeurNom;
  final String? editeurLieu;
  final String? copyright;
  final int? pages;
  final double? prix;

  final int? programmeId;
  final int? projetId;

  final String? statut;
  final String? commentaire;
  final String? info;

  Reference({
    this.id,
    this.globId,
    this.type,
    this.categorieId,
    this.titre,
    this.auteur,
    this.date,
    this.domaine,
    this.categ,
    this.desc,
    this.location,
    this.collection,
    this.source,
    this.section,
    this.page,
    this.txtSection,
    this.pdf,
    this.format,
    this.medium,
    this.isbn,
    this.editeurNom,
    this.editeurLieu,
    this.copyright,
    this.pages,
    this.prix,
    this.programmeId,
    this.projetId,
    this.statut,
    this.commentaire,
    this.info,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Reference.fromJson(Map<String, dynamic> json) {
    return Reference(
      id: json['id'],
      globId: json['glob_id'],
      type: json['type'],
      categorieId: json['categorie_id'],
      titre: json['titre'],
      auteur: json['auteur'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      domaine: json['domaine'],
      categ: json['categ'],
      desc: json['desc'],
      location: json['location'],
      collection: json['collection'],
      source: json['source'],
      section: json['section'],
      page: json['page'],
      txtSection: json['txt_section'],
      pdf: json['pdf'],
      format: json['format'],
      medium: json['medium'],
      isbn: json['ISBN'],
      editeurNom: json['editeur_nom'],
      editeurLieu: json['editeur_lieu'],
      copyright: json['copyright'],
      pages: json['pages'],
      prix: json['prix'] != null ? (json['prix'] as num).toDouble() : null,
      programmeId: json['programme_id'],
      projetId: json['projet_id'],
      statut: json['statut'],
      commentaire: json['commentaire'],
      info: json['info'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'glob_id': globId,
      'type': type,
      'categorie_id': categorieId,
      'titre': titre,
      'auteur': auteur,
      'date': date?.toIso8601String(),
      'domaine': domaine,
      'categ': categ,
      'desc': desc,
      'location': location,
      'collection': collection,
      'source': source,
      'section': section,
      'page': page,
      'txt_section': txtSection,
      'pdf': pdf,
      'format': format,
      'medium': medium,
      'ISBN': isbn,
      'editeur_nom': editeurNom,
      'editeur_lieu': editeurLieu,
      'copyright': copyright,
      'pages': pages,
      'prix': prix,
      'programme_id': programmeId,
      'projet_id': projetId,
      'statut': statut,
      'commentaire': commentaire,
      'info': info,
    };
  }
}