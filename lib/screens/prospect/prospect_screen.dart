// ssc1_app/lib/screens/prospect/prospect_screen.dart
//
// Écran principal : Prospect (version SSC1)
// ----------------------------------------
// Sert de point d’entrée au module Prospect.
// Affiche simplement la liste des prospects.
//
// Navigation SSC1 :
// ProspectScreen ? ProspectList ? ProspectDetail / ProspectForm
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'prospect_list.dart';

class ProspectScreen extends StatelessWidget {
  const ProspectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ProspectList(),
    );
  }
}