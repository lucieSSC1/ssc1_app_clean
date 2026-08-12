// lib/screens/documents/document_liste.dart

import 'package:flutter/material.dart';
import '../../services/document_service.dart';
import '../../models/document.dart';
import 'document_opener.dart';
import 'document_form.dart';

class DocumentListe extends StatefulWidget {
  const DocumentListe({super.key});

  @override
  State<DocumentListe> createState() => _DocumentListeState();
}

class _DocumentListeState extends State<DocumentListe> {
  List<DocumentSSC1> documents = [];

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    documents = await DocumentService().getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des documents")),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final d = documents[index];
          return ListTile(
            title: Text(d.titre),
            subtitle: Text(d.dateSaisie?.toIso8601String() ?? ""),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DocumentOpener(document: d)),
              );
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DocumentForm(document: d)),
              );
            },
          );
        },
      ),
    );
  }
}
