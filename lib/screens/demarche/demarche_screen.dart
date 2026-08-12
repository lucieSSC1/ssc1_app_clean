// ssc1_app/lib/screens/demarche/demarche_screen.dart
//
// Écran principal : Démarche (version SSC1, sans accents)
// -------------------------------------------------------
// Sert de point d’entrée au module Démarche.
// Affiche simplement la liste des démarches.
//
// Navigation SSC1 :
// DemarcheScreen ? DemarcheList ? DemarcheDetail / DemarcheForm
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'demarche_list.dart';

class DemarcheScreen extends StatelessWidget {
  const DemarcheScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DemarcheList(),
    );
  }
}