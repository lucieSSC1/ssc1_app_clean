// ============================================================
// FICHIER : lib/screens/document/documents_home.dart
// Accueil SSC1 - Gestionnaire de documents
// ============================================================

import 'package:flutter/material.dart';

import 'document_list.dart';

class DocumentsHome extends StatelessWidget {
  const DocumentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        height: 60,
        child: ElevatedButton(
          child: const Text("Gestionnaire de documents"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DocumentList()),
            );
          },
        ),
      ),
    );
  }
}
