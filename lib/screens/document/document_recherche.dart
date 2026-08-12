// lib/screens/documents/document_recherche.dart

import 'package:flutter/material.dart';
import '../../services/document_service.dart';
import '../../models/document.dart';
import 'document_opener.dart';

class DocumentRecherche extends StatefulWidget {
  const DocumentRecherche({super.key});

  @override
  State<DocumentRecherche> createState() => _DocumentRechercheState();
}

class _DocumentRechercheState extends State<DocumentRecherche> {
  final titre = TextEditingController();
  final mot1 = TextEditingController();
  final mot2 = TextEditingController();
  final mot3 = TextEditingController();

  String mode = "ET";
  List<DocumentSSC1> resultats = [];

  Future<void> rechercher() async {
    resultats = await DocumentService().search(
      titre.text,
      mot1.text,
      mot2.text,
      mot3.text,
      mode,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche avancée")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: titre, decoration: const InputDecoration(labelText: "Titre")),
            TextField(controller: mot1, decoration: const InputDecoration(labelText: "Mot-clé 1")),
            TextField(controller: mot2, decoration: const InputDecoration(labelText: "Mot-clé 2")),
            TextField(controller: mot3, decoration: const InputDecoration(labelText: "Mot-clé 3")),

            const SizedBox(height: 20),

            DropdownButton<String>(
              value: mode,
              items: const [
                DropdownMenuItem(value: "ET", child: Text("Mode ET")),
                DropdownMenuItem(value: "OU", child: Text("Mode OU")),
              ],
              onChanged: (v) => setState(() => mode = v!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: rechercher,
              child: const Text("Rechercher"),
            ),

            const SizedBox(height: 20),

            ...resultats.map((d) => ListTile(
              title: Text(d.titre),
              subtitle: Text(d.dateSaisie?.toIso8601String() ?? ""),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DocumentOpener(document: d)),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}