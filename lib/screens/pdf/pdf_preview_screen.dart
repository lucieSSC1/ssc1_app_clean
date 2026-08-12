// lib/screens/pdf/pdf_preview_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewScreen extends StatelessWidget {
  final Uint8List data;

  PdfPreviewScreen(this.data);

  @override
  Widget build(BuildContext context) {
    final pdf = PdfDocument.openData(data);

    return Scaffold(
      appBar: AppBar(title: Text("Aperçu PDF")),
      body: PdfView(
        controller: PdfController(document: pdf),
      ),
    );
  }
}