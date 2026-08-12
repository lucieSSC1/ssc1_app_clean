// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/projet_modification_screen.dart
// -----------------------------------------------------------------------------
// Ajout / Modification d’un projet (Structure 4)
// Equivalent de form_projet_modification.dart dans Structure 2
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';

import '../../api/projet_api.dart';
import '../../models/projet_model.dart';

class ProjetModificationScreen extends StatefulWidget {
  final ProjetModel? projet;

  const ProjetModificationScreen({
    super.key,
    this.projet,
  });

  @override
  State<ProjetModificationScreen> createState() =>
      _ProjetModificationScreenState();
}

class _ProjetModificationScreenState
    extends State<ProjetModificationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _dateDebutCtrl;
  late TextEditingController _dateFinCtrl;
  late TextEditingController _heuresPrevuesCtrl;

  bool _chargement = false;

  @override
  void initState() {
    super.initState();

    final p = widget.projet;

    _nomCtrl = TextEditingController(text: p?.nom ?? "");
    _descriptionCtrl = TextEditingController(text: p?.description ?? "");
    _dateDebutCtrl = TextEditingController(text: p?.dateDebut ?? "");
    _dateFinCtrl = TextEditingController(text: p?.dateFin ?? "");
    _heuresPrevuesCtrl = TextEditingController(
      text: p?.heuresPrevues != null ? p!.heuresPrevues.toString() : "",
    );
  }

  // ---------------------------------------------------------------------------
  // ENREGISTRER
  // ---------------------------------------------------------------------------
  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _chargement = true);

    final p = ProjetModel(
      id: widget.projet?.id ?? 0,
      nom: _nomCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      dateDebut: _dateDebutCtrl.text.trim(),
      dateFin: _dateFinCtrl.text.trim(),
      heuresPrevues: double.tryParse(_heuresPrevuesCtrl.text.trim()),
      heuresTravaillees: widget.projet?.heuresTravaillees,
    );

    if (widget.projet == null) {
      await ProjetApi.insertProjet(p);
    } else {
      await ProjetApi.updateProjet(p);
    }

    setState(() => _chargement = false);

    if (mounted) Navigator.pop(context);
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final bool modification = widget.projet != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(modification ? "Modifier projet" : "Ajouter projet"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              // NOM
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom du projet"),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Nom requis" : null,
              ),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 2,
              ),

              // DATE DÉBUT
              TextFormField(
                controller: _dateDebutCtrl,
                decoration:
                    const InputDecoration(labelText: "Date début (DD-MM-YYYY)"),
              ),

              // DATE FIN
              TextFormField(
                controller: _dateFinCtrl,
                decoration:
                    const InputDecoration(labelText: "Date fin (DD-MM-YYYY)"),
              ),

              // HEURES PRÉVUES
              TextFormField(
                controller: _heuresPrevuesCtrl,
                decoration: const InputDecoration(labelText: "Heures prévues"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

              if (_chargement) const LinearProgressIndicator(),

              const SizedBox(height: 20),

              // BOUTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _enregistrer,
                      child: const Text("Enregistrer"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}