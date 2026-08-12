// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/sections/definition.dart
// -----------------------------------------------------------------------------
// Section Définition du module Projet
//   • Lots
//   • Tâches
//   • Activités
//
// Fidèle à ton logiciel Access : cette section agit comme un HUB.
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../projet_controller.dart';
import '../sous_formulaires/lot_subform.dart';
import '../sous_formulaires/tache_subform.dart';
import '../sous_formulaires/activite_subform.dart';

class DefinitionSection extends StatelessWidget {
  const DefinitionSection({super.key});

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
                  "Définition",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (isMobile)
                  Column(
                    children: [
                      _btnLots(context, disabled),
                      const SizedBox(height: 8),
                      _btnTaches(context, disabled),
                      const SizedBox(height: 8),
                      _btnActivites(context, disabled),
                    ],
                  ),

                if (!isMobile)
                  Row(
                    children: [
                      Expanded(child: _btnLots(context, disabled)),
                      const SizedBox(width: 12),
                      Expanded(child: _btnTaches(context, disabled)),
                      const SizedBox(width: 12),
                      Expanded(child: _btnActivites(context, disabled)),
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
  // BOUTON : LOTS
  // ---------------------------------------------------------------------------
  Widget _btnLots(BuildContext context, bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LotSubform()),
              );
            },
      child: const Text("Lots"),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : TÂCHES
  // ---------------------------------------------------------------------------
  Widget _btnTaches(BuildContext context, bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TacheSubform()),
              );
            },
      child: const Text("Tâches"),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : ACTIVITÉS
  // ---------------------------------------------------------------------------
  Widget _btnActivites(BuildContext context, bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ActiviteSubform()),
              );
            },
      child: const Text("Activités"),
    );
  }
}