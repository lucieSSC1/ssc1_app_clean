// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/sections/suivi.dart
// -----------------------------------------------------------------------------
// Section Suivi du module Projet
//   • Avancement du projet
//   • Cédule du projet (unique)
//
// Fidèle à ton logiciel Access : cette section agit comme un HUB.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../projet_controller.dart';

class SuiviSection extends StatelessWidget {
  const SuiviSection({super.key});

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
                  "Suivi",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (isMobile)
                  Column(
                    children: [
                      _btnAvancement(disabled),
                      const SizedBox(height: 8),
                      _btnCedule(disabled),
                    ],
                  ),

                if (!isMobile)
                  Row(
                    children: [
                      Expanded(child: _btnAvancement(disabled)),
                      const SizedBox(width: 12),
                      Expanded(child: _btnCedule(disabled)),
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
  // BOUTON : Avancement du projet
  // ---------------------------------------------------------------------------
  Widget _btnAvancement(bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              // TODO : Navigation vers l’écran Avancement
            },
      child: const Text("Avancement"),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : Cédule du projet
  // ---------------------------------------------------------------------------
  Widget _btnCedule(bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              // TODO : Navigation vers l’écran Cédule du projet
            },
      child: const Text("Cédule du projet"),
    );
  }
}