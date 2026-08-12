// lib/screens/documents/document_form.dart

import 'package:flutter/material.dart';
import '../../models/document.dart';
import '../../services/document_service.dart';

class DocumentForm extends StatefulWidget {
  final DocumentSSC1? document;

  const DocumentForm({super.key, this.document});

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titre;
  late TextEditingController mot1;
  late TextEditingController mot2;
  late TextEditingController mot3;
  late TextEditingController rem;

  DateTime? dateSaisie;
  String? fichierUrl;

  @override
  void initState() {
    super.initState();

    final d = widget.document;

    titre = TextEditingController(text: d?.titre ?? "");
    mot1 = TextEditingController(text: d?.motCle1 ?? "");
    mot2 = TextEditingController(text: d?.motCle2 ?? "");
    mot3 = TextEditingController(text: d?.motCle3 ?? "");
    rem = TextEditingController(text: d?.rem ?? "");

    dateSaisie = d?.dateSaisie;
    fichierUrl = d?.documentUrl;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateSaisie ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => dateSaisie = picked);
    }
  }

  Future<void> _uploadFile() async {
    final url = await DocumentService().uploadFile();
    setState(() => fichierUrl = url);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final doc = DocumentSSC1(
      id: widget.document?.id ?? 0,
      globId: widget.document?.globId,
      dateSaisie: dateSaisie,
      titre: titre.text,
      motCle1: mot1.text,
      motCle2: mot2.text,
      motCle3: mot3.text,
      documentUrl: fichierUrl,
      rem: rem.text,
    );

    if (widget.document == null) {
      await DocumentService().create(doc);
    } else {
      await DocumentService().update(doc);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document == null
            ? "Ajouter un document"
            : "Modifier un document"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titre,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (v) => v!.isEmpty ? "Obligatoire" : null,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _selectDate,
                child: Text(dateSaisie == null
                    ? "Date de saisie"
                    : dateSaisie!.toIso8601String()),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: mot1,
                decoration: const InputDecoration(labelText: "Mot-clé 1"),
              ),
              TextFormField(
                controller: mot2,
                decoration: const InputDecoration(labelText: "Mot-clé 2"),
              ),
              TextFormField(
                controller: mot3,
                decoration: const InputDecoration(labelText: "Mot-clé 3"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _uploadFile,
                child: Text(fichierUrl == null
                    ? "Téléverser un fichier"
                    : "Fichier téléversé"),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: rem,
                decoration: const InputDecoration(labelText: "Remarques"),
                maxLines: 3,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _save,
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
