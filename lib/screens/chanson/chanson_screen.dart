// ssc1_app/lib/screens/chanson/chanson_screen.dart
//
// Écran principal : Chanson (module Loisir - SSC1)
// ------------------------------------------------
// Sert de point d’entrée au module Chanson.
// Affiche simplement la liste des chansons.
//
// Navigation SSC1 :
// ChansonScreen ? ChansonList ? ChansonDetail / ChansonForm

import 'package:flutter/material.dart';

import 'chanson_list.dart';

class ChansonScreen extends StatelessWidget {
  const ChansonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ChansonList(),
    );
  }
}