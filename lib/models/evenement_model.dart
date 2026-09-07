// ============================================================
// FICHIER : lib/models/evenement_model.dart
// Modèle Événement — Version SSC1 (propre + uniforme)
// ============================================================

class EvenementModel {
  final int? id; // ID visible (eve_id)
  final int? globId; // FK interne → glob_info.id
  final String nom; // Titre / nom de l’événement
  final int? categorie; // Catégorie (event_categ.id)
  final String? motCle1;
  final String? motCle2;
  final String? motCle3;
  final String? description;

  EvenementModel({
    required this.id,
    required this.globId,
    required this.nom,
    required this.categorie,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.description,
  });

  // ------------------------------------------------------------
  // DEBUG SSC1
  // ------------------------------------------------------------
  void debugPrint() {
    print("DEBUG-EVT: {");
    print("  id: $id");
    print("  globId: $globId");
    print("  nom: $nom");
    print("  categorie: $categorie");
    print("  motCle1: $motCle1");
    print("  motCle2: $motCle2");
    print("  motCle3: $motCle3");
    print("  description: $description");
    print("}");
  }

  // ------------------------------------------------------------
  // Conversion Supabase → modèle
  // ------------------------------------------------------------
  factory EvenementModel.fromMap(Map<String, dynamic> map) {
    final evt = EvenementModel(
      id: map['id'] as int?,
      globId: map['glob_id'] as int?,
      nom: map['nom'] ?? "",
      categorie: map['categorie'] as int?,
      motCle1: map['mot_cle1'] as String?,
      motCle2: map['mot_cle2'] as String?,
      motCle3: map['mot_cle3'] as String?,
      description: map['description'] as String?,
    );

    print("DEBUG-EVT: fromMap() → événement chargé");
    evt.debugPrint();

    return evt;
  }
}
