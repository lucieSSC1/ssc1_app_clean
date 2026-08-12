// ssc1_app/lib/screens/etudes/cours_screen.dart
//
// Écran principal : Cours (version SSC1)
// --------------------------------------
// Sert de point d’entrée au module Cours.
// Affiche simplement la liste des cours.
//
// Navigation SSC1 :
// CoursScreen ? CoursList ? CoursDetail / CoursForm
//
// Ce fichier n’existait pas dans structure 2 : il est créé pour SSC1.

import 'package:flutter/material.dart';

import 'cours_list.dart';

class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CoursList(),
    );
  }
}