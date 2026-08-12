// ssc1_app/lib/screens/recette/recette_screen.dart
//
// Écran principal : Recette (module Loisir - SSC1)
// ------------------------------------------------
// Sert de point d’entrée au module Recette.
// Affiche simplement la liste des recettes.
//
// Navigation SSC1 :
// RecetteScreen ? RecetteList ? RecetteDetail / RecetteForm

import 'package:flutter/material.dart';

import 'recette_list.dart';

class RecetteScreen extends StatelessWidget {
  const RecetteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RecetteList(),
    );
  }
}