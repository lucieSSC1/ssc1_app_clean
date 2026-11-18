// ============================================================
// FICHIER : lib/models/chronologie_item.dart
// SSC1 - Générateur de chronologie
// ============================================================

class ChronologieItem {
  final DateTime debut;
  final DateTime? fin;

  final String type;

  final String description;

  const ChronologieItem({
    required this.debut,
    this.fin,
    required this.type,
    required this.description,
  });
}