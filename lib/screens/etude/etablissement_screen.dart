// ssc1_app/lib/screens/etudes/etablissement_screen.dart
//
// Écran principal : Établissements (version SSC1)
// ------------------------------------------------
// Sert de point d’entrée au module Établissements.
// Affiche simplement la liste des établissements.
//
// Navigation SSC1 :
// EtablissementScreen ? EtablissementList ? EtablissementDetail / EtablissementForm
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'etablissement_list.dart';

class EtablissementScreen extends StatelessWidget {
  const EtablissementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EtablissementList(),
    );
  }
}