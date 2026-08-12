// ssc1_app/lib/screens/biographie/reference_screen.dart
//
// �cran principal : R�f�rences (module Biographie)
// ------------------------------------------------
// Sert de point d�entr�e au module R�f�rences.
// Affiche simplement la liste des r�f�rences.
//
// Navigation SSC1 :
// ReferenceScreen ? ReferenceList ? ReferenceDetail / ReferenceForm
//
// Ce fichier n�existait pas dans structure 2 : il est cr�� pour SSC1.

import 'package:flutter/material.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Module Références (à compléter)",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
