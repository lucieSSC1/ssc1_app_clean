import 'package:flutter/material.dart';

// Import des écrans internes
import 'identite_screen.dart';
import 'residence_screen.dart';
import 'acquisition_screen.dart';
import 'reference_screen.dart';

import 'evenement_list.dart'; // ✔ module moderne Supabase
import 'evenement_search.dart'; // ✔ si tu veux ajouter la recherche plus tard

class BiographieHome extends StatelessWidget {
  const BiographieHome({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildButtonGrid(context, [
      _BiographieItem("Identité", IdentiteScreen()),
      _BiographieItem("Résidences", ResidencesScreen()),
      _BiographieItem("Acquisitions", AcquisitionsScreen()),
      _BiographieItem("Références", ReferencesScreen()),
      _BiographieItem("Événements", const EvenementList()), // ✔ CORRIGÉ
    ]);
  }

  Widget _buildButtonGrid(BuildContext context, List<_BiographieItem> items) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3,
        children: [
          for (final item in items)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => item.screen),
                );
              },
              child: Text(item.label),
            ),
        ],
      ),
    );
  }
}

class _BiographieItem {
  final String label;
  final Widget screen;

  _BiographieItem(this.label, this.screen);
}
