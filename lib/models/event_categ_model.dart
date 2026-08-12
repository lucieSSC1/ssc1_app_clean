// ============================================================
// FICHIER : lib/models/event_categ_model.dart
// Modèle Catégorie — Compact + Propre
// ============================================================

class EventCateg {
  final int id;
  final String nom;

  EventCateg({required this.id, required this.nom});

  factory EventCateg.fromMap(Map<String, dynamic> map) {
    return EventCateg(id: map['id'] as int, nom: map['nom'] as String);
  }
}
