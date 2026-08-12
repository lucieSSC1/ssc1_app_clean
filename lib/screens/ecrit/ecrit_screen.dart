// ssc1_app/lib/screens/ecrit/ecrit_screen.dart
//
// Écran principal : Écrit (module Loisir - SSC1)
// ----------------------------------------------
// Sert de point d’entrée au module Écrit.
// Affiche simplement la liste des écrits.
//
// Navigation SSC1 :
// EcritScreen ? EcritList ? EcritDetail / EcritForm

import 'package:flutter/material.dart';

import 'ecrit_list.dart';

class EcritScreen extends StatelessWidget {
  const EcritScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EcritList(),
    );
  }
}