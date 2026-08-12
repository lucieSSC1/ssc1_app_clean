// ssc1_app/lib/screens/biographie/acquisition_screen.dart
//
// �cran principal : Acquisition (module Biographie)
// -------------------------------------------------
// Cet �cran sert de point d�entr�e au module Acquisition.
// Il affiche simplement la liste des acquisitions.
//
// Navigation SSC1 :
// AcquisitionScreen ? AcquisitionList ? AcquisitionDetail / AcquisitionForm
//
// Ce fichier remplace compl�tement l�ancien prototype de structure 4.

import 'package:flutter/material.dart';

class AcquisitionsScreen extends StatelessWidget {
  const AcquisitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Module Acquisitions (à compléter)",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
