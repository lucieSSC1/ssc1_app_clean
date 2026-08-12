// -----------------------------------------------------------------------------
// FICHIER : ssc1_app/lib/screens/projet/projet_form.dart
// -----------------------------------------------------------------------------
// Formulaire principal du module Projet (Structure 4)
//   • Sélecteur de projet
//   • Champs du projet
//   • Champs calculés
//   • Boutons : Définition, Info projet, Ressources
//   • Bouton : Journal
//   • Zone : Documents
//
// Fidèle à Structure 2 (Access)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'projet_controller.dart';
import 'projet_selector.dart';
import 'projet_fields.dart';
import 'projet_calculs.dart';

class ProjetForm extends StatelessWidget {
  const ProjetForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProjetController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Projet"),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          if (isMobile) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProjetSelector(),
                  const SizedBox(height: 12),
                  const ProjetFormFields(),
                  const SizedBox(height: 12),
                  const ProjetFormCalculs(),
                  const SizedBox(height: 20),

                  // -------------------------------------------------------------
                  // ZONE 1 — DÉFINITION
                  // -------------------------------------------------------------
                  _zoneDefinition(context),

                  const SizedBox(height: 12),

                  // -------------------------------------------------------------
                  // ZONE 2 — JOURNAL
                  // -------------------------------------------------------------
                  _zoneJournal(context),

                  const SizedBox(height: 12),

                  // -------------------------------------------------------------
                  // ZONE 3 — DOCUMENTS
                  // -------------------------------------------------------------
                  _zoneDocuments(context),
                ],
              ),
            );
          }

          // -------------------------------------------------------------------
          // VERSION DESKTOP : deux colonnes
          // -------------------------------------------------------------------
          return Row(
            children: [
              // Colonne gauche
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      ProjetSelector(),
                      SizedBox(height: 16),
                      ProjetFormFields(),
                      SizedBox(height: 16),
                      ProjetFormCalculs(),
                    ],
                  ),
                ),
              ),

              // Colonne droite
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _zoneDefinition(context),
                      const SizedBox(height: 16),
                      _zoneJournal(context),
                      const SizedBox(height: 16),
                      _zoneDocuments(context),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================================
  // ZONE 1 — DÉFINITION
  // ============================================================================
  Widget _zoneDefinition(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Définition",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO : ouvrir Définition (Lots/Tâches/Activités)
                  },
                  child: const Text("Définition"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO : ouvrir Info projet
                  },
                  child: const Text("Info projet"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO : ouvrir Ressources
                  },
                  child: const Text("Ressources"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // ZONE 2 — JOURNAL
  // ============================================================================
  Widget _zoneJournal(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Détail du travail effectué",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // TODO : ouvrir Journal (rapport)
              },
              child: const Text("Journal"),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // ZONE 3 — DOCUMENTS
  // ============================================================================
  Widget _zoneDocuments(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Documents associés",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Répertoire",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                // TODO : mettre à jour directory
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                // TODO : ouvrir gestion des documents
              },
              child: const Text("Ouvrir documents"),
            ),
          ],
        ),
      ),
    );
  }
}