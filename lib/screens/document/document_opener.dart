// lib/screens/documents/document_opener.dart

import 'package:flutter/material.dart';
import '../../models/document.dart';
import 'package:open_filex/open_filex.dart';

class DocumentOpener extends StatelessWidget {
  final DocumentSSC1 document;

  const DocumentOpener({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(document.titre)),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (document.documentUrl != null) {
              OpenFilex.open(document.documentUrl!);
            }
          },
          child: const Text("Ouvrir le document"),
        ),
      ),
    );
  }
}