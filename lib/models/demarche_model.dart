// ssc1_app/lib/models/demarche_model.dart
//
// Modèle : Démarche (version SSC1, sans accents dans les champs)

class Demarche {
  final int? id;
  final DateTime? date;
  final String? domaine;
  final String? service;
  final String? serviceDetails;
  final String? motCle1;
  final String? motCle2;
  final String? motCle3;
  final int? prospId;
  final bool? pending;
  final bool? entente;
  final String? interactions;
  final String? lettreUrl;
  final String? cvUrl;
  final String? preparationUrl;

  Demarche({
    this.id,
    this.date,
    this.domaine,
    this.service,
    this.serviceDetails,
    this.motCle1,
    this.motCle2,
    this.motCle3,
    this.prospId,
    this.pending,
    this.entente,
    this.interactions,
    this.lettreUrl,
    this.cvUrl,
    this.preparationUrl,
  });

  factory Demarche.fromJson(Map<String, dynamic> json) {
    return Demarche(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      domaine: json['domaine'],
      service: json['service'],
      serviceDetails: json['service_details'],
      motCle1: json['mot_cle1'],
      motCle2: json['mot_cle2'],
      motCle3: json['mot_cle3'],
      prospId: json['prosp_id'],
      pending: json['pending'],
      entente: json['entente'],
      interactions: json['interactions'],
      lettreUrl: json['lettre_url'],
      cvUrl: json['cv_url'],
      preparationUrl: json['preparation_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'domaine': domaine,
      'service': service,
      'service_details': serviceDetails,
      'mot_cle1': motCle1,
      'mot_cle2': motCle2,
      'mot_cle3': motCle3,
      'prosp_id': prospId,
      'pending': pending,
      'entente': entente,
      'interactions': interactions,
      'lettre_url': lettreUrl,
      'cv_url': cvUrl,
      'preparation_url': preparationUrl,
    };
  }
}