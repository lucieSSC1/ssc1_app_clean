/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/projet/journal_projet_screen.dart
   ÉCRAN : Journal du projet (Structure 4, lecture seule)

   EN-TÊTE :
     - proj_id
     - proj_nom
     - total des heures travaillées du projet

   LIGNES (par journée) :
     - date
     - nb_heure_par_jour
     - objectif
     - description
     - suivi / suite

   PIED DE PAGE FIXE :
     - à gauche : date actuelle

   BOUTON :
     - Exporter en PDF

   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/journee_api.dart';
import '../../models/journee_model.dart';

import '../../reports/journal_projet_pdf.dart';   // <-- PDF

class JournalProjetScreen extends StatefulWidget {
  final int projetId;
  final String nomProjet;

  const JournalProjetScreen({
    super.key,
    required this.projetId,
    required this.nomProjet,
  });

  @override
  State<JournalProjetScreen> createState() => _JournalProjetScreenState();
}

class _JournalProjetScreenState extends State<JournalProjetScreen> {
  late Future<List<JourneeModel>> futureJournees;

  @override
  void initState() {
    super.initState();
    futureJournees = JourneeApi.getJourneesParProjet(widget.projetId);
  }

  double calculerTotal(List<JourneeModel> journees) {
    return journees.fold(0, (sum, j) => sum + j.heuresTravaillees);
  }

  String dateActuelle() {
    final now = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal du projet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Exporter en PDF",
            onPressed: () async {
              final journees = await futureJournees;
              final total = calculerTotal(journees);

              final pdfBytes = await generateJournalProjetPdf(
                projetId: widget.projetId,
                nomProjet: widget.nomProjet,
                totalHeures: total,
                journees: journees,
              );

              // Ouvre le PDF
              await saveAndOpenPdf(
                bytes: pdfBytes,
                filename: "journal_projet_${widget.projetId}.pdf",
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<JourneeModel>>(
        future: futureJournees,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final journees = snapshot.data!;
          final totalHeures = calculerTotal(journees);

          return Column(
            children: [
              // -----------------------------------------------------------
              // EN-TÊTE
              // -----------------------------------------------------------
              Container(
                width: double.infinity,
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Projet #${widget.projetId} — ${widget.nomProjet}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total heures travaillées : ${totalHeures.toStringAsFixed(1)} h",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // -----------------------------------------------------------
              // LISTE DES JOURNÉES
              // -----------------------------------------------------------
              Expanded(
                child: ListView.builder(
                  itemCount: journees.length,
                  itemBuilder: (context, index) {
                    final j = journees[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${j.date} — ${j.heuresTravaillees.toStringAsFixed(1)} h",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            if ((j.objectif ?? "").isNotEmpty) ...[
                              Text("Objectif : ${j.objectif}"),
                              const SizedBox(height: 4),
                            ],

                            if ((j.description ?? "").isNotEmpty) ...[
                              Text("Description : ${j.description}"),
                              const SizedBox(height: 4),
                            ],

                            if ((j.suite ?? "").isNotEmpty) ...[
                              Text("Suivi : ${j.suite}"),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      // -----------------------------------------------------------
      // PIED DE PAGE FIXE
      // -----------------------------------------------------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.grey.shade200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              dateActuelle(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}