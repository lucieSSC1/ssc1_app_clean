// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/projet_form_calculs.dart
// -----------------------------------------------------------------------------
// (Suite de la partie 1)
// -----------------------------------------------------------------------------

          // -------------------------------------------------------------------
          // MOBILE : affichage vertical
          // -------------------------------------------------------------------
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildFields(),
          );
        }

        // ---------------------------------------------------------------------
        // DESKTOP : affichage horizontal
        // ---------------------------------------------------------------------
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildFields(),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LISTE DES CHAMPS CALCULÉS (dans l’ordre imposé)
  // ---------------------------------------------------------------------------
  List<Widget> _buildFields() {
    return [
      // 1. % complété
      _buildValueBox(
        label: "% complété",
        value: controller.pourcentageCompletion == null
            ? "—"
            : "${controller.pourcentageCompletion!.toStringAsFixed(1)} %",
      ),

      // 2. Heures travaillées
      _buildValueBox(
        label: "Heures travaillées",
        value: controller.heuresTravaillees == null
            ? "—"
            : controller.heuresTravaillees!.toStringAsFixed(1),
      ),

      // 3. Heures totales
      _buildValueBox(
        label: "Heures totales",
        value: controller.heuresTotales == null
            ? "—"
            : controller.heuresTotales!.toStringAsFixed(1),
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // BOÎTE D’AFFICHAGE D’UNE VALEUR CALCULÉE
  // ---------------------------------------------------------------------------
  Widget _buildValueBox({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}