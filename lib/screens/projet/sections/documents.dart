// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/sections/documents.dart
// -----------------------------------------------------------------------------
// Section Documents du module Projet
//   • Chronique
//   • Répertoire
//
// Fidèle à ton logiciel Access : cette section agit comme un HUB.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../projet_controller.dart';

class DocumentsSection extends StatelessWidget {
  const DocumentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProjetController>(context);
    final projet = controller.projetActif;

    final bool disabled = projet == null;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Documents",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (isMobile)
                  Column(
                    children: [
                      _btnChronique(disabled),
                      const SizedBox(height: 8),
                      _btnRepertoire(disabled),
                    ],
                  ),

                if (!isMobile)
                  Row(
                    children: [
                      Expanded(child: _btnChronique(disabled)),
                      const SizedBox(width: 12),
                      Expanded(child: _btnRepertoire(disabled)),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : Chronique
  // ---------------------------------------------------------------------------
  Widget _btnChronique(bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              // TODO : Navigation vers l’écran Chronique
            },
      child: const Text("Chronique"),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : Répertoire
  // ---------------------------------------------------------------------------
  Widget _btnRepertoire(bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              // TODO : Navigation vers l’écran Répertoire
            },
      child: const Text("Répertoire"),
    );
  }
}