// ssc1_app/lib/screens/biographie/residence_screen.dart
//
// �cran principal : R�sidences (module Biographie)
// ------------------------------------------------
// Cet �cran sert de point d�entr�e au module R�sidences.
// Il affiche simplement la liste des r�sidences.
//
// Navigation SSC1 :
// ResidenceScreen ? ResidenceList ? ResidenceDetail / ResidenceForm
//
// Ce fichier n�existait pas dans structure 2 : il est cr�� pour SSC1.

import 'package:flutter/material.dart';

import 'residence_list.dart';

class ResidencesScreen extends StatelessWidget {
  const ResidencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: ResidenceList());
  }
}
