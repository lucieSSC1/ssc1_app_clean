// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/forms/proj_info_form.dart
// -----------------------------------------------------------------------------
// Zone de texte "proj_info" d’un projet
// - Affiche et édite le texte descriptif long du projet
// - À ouvrir depuis l’écran Projet via un bouton "Proj. info"
// -----------------------------------------------------------------------------


import 'package:flutter/material.dart';

class ProjInfoForm extends StatefulWidget {
  final String? texteInitial;

  const ProjInfoForm({
    super.key,
    this.texteInitial,
  });

  @override
  State<ProjInfoForm> createState() => _ProjInfoFormState();
}

class _ProjInfoFormState extends State<ProjInfoForm> {
  late TextEditingController _texteCtrl;

  @override
  void initState() {
    super.initState();
    _texteCtrl = TextEditingController(text: widget.texteInitial ?? "");
  }

  @override
  void dispose() {
    _texteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Information sur le projet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: "Enregistrer et fermer",
            onPressed: () {
              Navigator.pop(context, _texteCtrl.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _texteCtrl,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
            labelText: "Description détaillée du projet",
            hintText: "Saisir ici les informations générales, le contexte,\n"
                "les objectifs, les contraintes, les notes importantes, etc.",
          ),
        ),
      ),
    );
  }
}