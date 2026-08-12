// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/sections/detail.dart
// -----------------------------------------------------------------------------
// Section Détail du module Projet
//   • Journal (rapport direct)
//   • Info Projet (écran séparé, à coder plus tard)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../projet_controller.dart';
import '../../journal/rapport_journal.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({super.key});

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
                  "Détail",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (isMobile)
                  Column(
                    children: [
                      _btnJournal(context, disabled),
                      const SizedBox(height: 8),
                      _btnInfoProjet(disabled),
                    ],
                  ),

                if (!isMobile)
                  Row(
                    children: [
                      Expanded(child: _btnJournal(context, disabled)),
                      const SizedBox(width: 12),
                      Expanded(child: _btnInfoProjet(disabled)),
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
  // BOUTON : Journal (rapport direct)
  // ---------------------------------------------------------------------------
  Widget _btnJournal(BuildContext context, bool disabled) {
    return ElevatedButton(
      onPressed: disabled
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RapportJournal()),
              );
            },
      child: const Text("Journal"),
    );
  }

  // ---------------------------------------------------------------------------
  // BOUTON : Info Projet (écran à venir)
  // ---------------------------------------------------------------------------
  Widget _btnInfoProjet(bool disabled) {
    return ElevatedButton(
      onPressed: disabled ? null : () {},
      child: const Text("Info Projet"),
    );
  }
}