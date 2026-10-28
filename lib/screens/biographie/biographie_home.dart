// ssc1_app/lib/screens/biographie/biographie_home.dart
//
// Écran : Menu Biographie (version SSC1)
// --------------------------------------

import 'package:flutter/material.dart';

// Import des écrans internes
import 'identite_screen.dart';
import 'residence_screen.dart';
import '../acquisition/acquisition_list.dart';
import 'reference_screen.dart';

import 'evenement_list.dart';

class BiographieHome extends StatelessWidget {
  const BiographieHome({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildButtonGrid(context, [
      _BiographieItem("Identité", const IdentiteScreen()),
      _BiographieItem("Résidences", const ResidencesScreen()),
      _BiographieItem("Acquisitions", AcquisitionList()),
      _BiographieItem("Références", const ReferencesScreen()),
      _BiographieItem("Événements", EvenementList()),
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

  const _BiographieItem(this.label, this.screen);
}
