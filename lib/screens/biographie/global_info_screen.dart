// ssc1_app/lib/screens/biographie/global_info_screen.dart
//
// Écran principal du module GlobalInfo
// -------------------------------------
// Sert de point d’entrée pour :
// - Créer une GlobalInfo
// - Voir la liste complète
// - (optionnel) Rechercher une GlobalInfo
//
// Ce module est utilisé par :
// - Événement (globId ? GlobalInfo)
// - D’autres modules SSC1 plus tard

import 'package:flutter/material.dart';

import 'global_info_form.dart';
import 'global_info_list.dart';

class GlobalInfoScreen extends StatelessWidget {
  const GlobalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GlobalInfo")),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _btn(
              context,
              label: "Créer une GlobalInfo",
              screen: const GlobalInfoForm(),
            ),

            const SizedBox(height: 20),

            _btn(
              context,
              label: "Voir la liste complète",
              screen: const GlobalInfoList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(BuildContext context,
      {required String label, required Widget screen}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Text(label),
      ),
    );
  }
}