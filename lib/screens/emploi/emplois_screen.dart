// ssc1_app/lib/screens/emploi/emploi_screen.dart
//
// Écran principal : Emploi (version SSC1)
// ---------------------------------------
// Sert de point d’entrée au module Emploi.
// Affiche simplement la liste des emplois.
//
// Navigation SSC1 :
// EmploiScreen ? EmploiList ? EmploiDetail / EmploiForm
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'emploi_list.dart';

class EmploiScreen extends StatelessWidget {
  const EmploiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EmploiList(),
    );
  }
}