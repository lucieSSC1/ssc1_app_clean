// lib/screens/documents/documents_home.dart

import 'package:flutter/material.dart';
import 'document_list.dart';
import 'document_form.dart';
import 'document_recherche.dart';

class DocumentsHome extends StatelessWidget {
  const DocumentsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gestionnaire de documents")),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          _buildButton(
            context,
            "Liste des documents",
            Icons.list,
            const DocumentListe(),
          ),
          _buildButton(
            context,
            "Ajouter un document",
            Icons.add,
            const DocumentForm(),
          ),
          _buildButton(
            context,
            "Recherche avanc�e",
            Icons.search,
            const DocumentRecherche(),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
