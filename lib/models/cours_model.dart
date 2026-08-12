// ssc1_app/lib/models/cours_model.dart
//
// Modèle : Cours (version SSC1)
// -----------------------------
// Correspond EXACTEMENT à la table SQL "cours".
//
// Champs SQL :
// - id
// - glob_id
// - code
// - nom
// - desc
// - prog_id
// - session
// - note_num
// - note_alpha
// - categ
// - remarque
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

class Cours {
  final int? id;
  final int? globId;
  final String? code;
  final String? nom;
  final String? desc;
  final int? progId;
  final String? session;
  final int? noteNum;
  final String? noteAlpha;
  final int? categ;
  final String? remarque;

  Cours({
    this.id,
    this.globId,
    this.code,
    this.nom,
    this.desc,
    this.progId,
    this.session,
    this.noteNum,
    this.noteAlpha,
    this.categ,
    this.remarque,
  });

  // ------------------------------------------------------------
  // FROM JSON
  // ------------------------------------------------------------
  factory Cours.fromJson(Map<String, dynamic> json) {
    return Cours(
      id: json['id'],
      globId: json['glob_id'],
      code: json['code'],
      nom: json['nom'],
      desc: json['desc'],
      progId: json['prog_id'],
      session: json['session'],
      noteNum: json['note_num'],
      noteAlpha: json['note_alpha'],
      categ: json['categ'],
      remarque: json['remarque'],
    );
  }

  // ------------------------------------------------------------
  // TO JSON
  // ------------------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'glob_id': globId,
      'code': code,
      'nom': nom,
      'desc': desc,
      'prog_id': progId,
      'session': session,
      'note_num': noteNum,
      'note_alpha': noteAlpha,
      'categ': categ,
      'remarque': remarque,
    };
  }
}
