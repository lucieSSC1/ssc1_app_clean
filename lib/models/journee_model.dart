/* ---------------------------------------------------------------------------
   CHEMIN : lib/models/journee_model.dart
   DESCRIPTION : Modèle JOURNÉE (Structure 4)
   Champs dans l’ordre exact demandé :
   date ? heures_travaillees ? objectif ? description ? suite ? note
   --------------------------------------------------------------------------- */

class JourneeModel {
  final int id;
  final int activId;
  final String date;
  final double heuresTravaillees;
  final String? objectif;
  final String? description;
  final String? suite;
  final String? note;

  JourneeModel({
    required this.id,
    required this.activId,
    required this.date,
    required this.heuresTravaillees,
    this.objectif,
    this.description,
    this.suite,
    this.note,
  });

  factory JourneeModel.fromJson(Map<String, dynamic> json) {
    return JourneeModel(
      id: json['id'] as int,
      activId: json['activ_id'] as int,
      date: json['date'] as String,
      heuresTravaillees:
          (json['heures_travaillees'] as num).toDouble(),
      objectif: json['objectif'] as String?,
      description: json['description'] as String?,
      suite: json['suite'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activ_id': activId,
      'date': date,
      'heures_travaillees': heuresTravaillees,
      'objectif': objectif,
      'description': description,
      'suite': suite,
      'note': note,
    };
  }
}