// ============================================================
// FICHIER : lib/models/evenement_model.dart
// Modèle Événement — Version JOIN glob_info + DEBUG
// ============================================================

class EvenementModel {
  final int? id;
  final int? globId;
  final String nom;
  final int? categorie;
  final String? motCle1;
  final String? motCle2;
  final String? motCle3;
  final String? description;

  // Champs provenant de glob_info
  final DateTime? debut;
  final DateTime? fin;
  final String? type;

  EvenementModel({
    required this.id,
    required this.globId,
    required this.nom,
    required this.categorie,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.description,
    this.debut,
    this.fin,
    this.type,
  });

  // ------------------------------------------------------------
  // DEBUG interne (affiche un événement complet)
  // ------------------------------------------------------------
  void debugPrint() {
    print("DEBUG-MODEL: EvenementModel {");
    print("  id: $id");
    print("  globId: $globId");
    print("  nom: $nom");
    print("  categorie: $categorie");
    print("  motCle1: $motCle1");
    print("  motCle2: $motCle2");
    print("  motCle3: $motCle3");
    print("  description: $description");
    print("  debut: $debut");
    print("  fin: $fin");
    print("  type: $type");
    print("}");
  }

  // ------------------------------------------------------------
  // Conversion Supabase → modèle
  // ------------------------------------------------------------
  factory EvenementModel.fromMap(Map<String, dynamic> map) {
    // Lecture du bloc relationnel glob_info
    final glob = map['glob_info'] as Map<String, dynamic>?;

    final evt = EvenementModel(
      id: map['id'] as int?,
      globId: map['glob_id'] as int?,
      nom: map['nom'] ?? "",
      categorie: map['categorie'] as int?,
      motCle1: map['mot_cle1'] as String?,
      motCle2: map['mot_cle2'] as String?,
      motCle3: map['mot_cle3'] as String?,
      description: map['description'] as String?,

      // Dates provenant de glob_info
      debut: glob?['debut'] != null ? DateTime.parse(glob!['debut']) : null,
      fin: glob?['fin'] != null ? DateTime.parse(glob!['fin']) : null,

      // Type provenant de glob_info
      type: glob?['type'] as String?,
    );

    print("DEBUG-MODEL: fromMap() → événement chargé :");
    evt.debugPrint();

    return evt;
  }

  // ------------------------------------------------------------
  // Formatage dates compact
  // ------------------------------------------------------------
  String debutStr() {
    if (debut == null) return "—";
    return "${debut!.day.toString().padLeft(2, '0')}-"
        "${debut!.month.toString().padLeft(2, '0')}-"
        "${debut!.year}";
  }

  String finStr() {
    if (fin == null) return "—";
    return "${fin!.day.toString().padLeft(2, '0')}-"
        "${fin!.month.toString().padLeft(2, '0')}-"
        "${fin!.year}";
  }
}
