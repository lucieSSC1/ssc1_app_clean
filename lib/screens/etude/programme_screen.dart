// ssc1_app/lib/screens/etudes/programme_screen.dart
//
// Écran principal : Programmes (version SSC1)
// -------------------------------------------
// Sert de point d’entrée au module Programmes.
// Affiche simplement la liste des programmes.
//
// Navigation SSC1 :
// ProgrammeScreen ? ProgrammeList ? ProgrammeDetail / ProgrammeForm
//
// Ce fichier était vide dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'programme_list.dart';

class ProgrammeScreen extends StatelessWidget {
  const ProgrammeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProgrammeList(),
    );
  }
}