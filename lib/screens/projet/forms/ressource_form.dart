// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/projet/forms/ressource_form.dart
// -----------------------------------------------------------------------------
// Formulaire d’ajout / modification d’une ressource
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../../models/ressource_model.dart';

class RessourceForm extends StatefulWidget {
  final RessourceModel? ressource;

  const RessourceForm({super.key, this.ressource});

  @override
  State<RessourceForm> createState() => _RessourceFormState();
}

class _RessourceFormState extends State<RessourceForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomCtrl;
  late TextEditingController _compagnieCtrl;
  late TextEditingController _tauxCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _faxCtrl;
  late TextEditingController _courrielCtrl;
  late TextEditingController _adresseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _codePostalCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _servicesCtrl;
  late TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();

    final r = widget.ressource;

    _nomCtrl = TextEditingController(text: r?.nom ?? "");
    _compagnieCtrl = TextEditingController(text: r?.compagnie ?? "");
    _tauxCtrl = TextEditingController(text: r?.tauxHoraire?.toString() ?? "");
    _telCtrl = TextEditingController(text: r?.telephone ?? "");
    _faxCtrl = TextEditingController(text: r?.fax ?? "");
    _courrielCtrl = TextEditingController(text: r?.courriel ?? "");
    _adresseCtrl = TextEditingController(text: r?.adresse ?? "");
    _villeCtrl = TextEditingController(text: r?.ville ?? "");
    _codePostalCtrl = TextEditingController(text: r?.codePostal ?? "");
    _descriptionCtrl = TextEditingController(text: r?.description ?? "");
    _servicesCtrl = TextEditingController(text: r?.services ?? "");
    _noteCtrl = TextEditingController(text: r?.note ?? "");
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _compagnieCtrl.dispose();
    _tauxCtrl.dispose();
    _telCtrl.dispose();
    _faxCtrl.dispose();
    _courrielCtrl.dispose();
    _adresseCtrl.dispose();
    _villeCtrl.dispose();
    _codePostalCtrl.dispose();
    _descriptionCtrl.dispose();
    _servicesCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ressource == null
            ? "Ajouter une ressource"
            : "Modifier la ressource"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final r = RessourceModel(
                  id: widget.ressource?.id ?? 0,
                  nom: _nomCtrl.text,
                  compagnie: _compagnieCtrl.text,
                  tauxHoraire: _tauxCtrl.text.isEmpty
                      ? null
                      : double.tryParse(_tauxCtrl.text),
                  telephone: _telCtrl.text,
                  fax: _faxCtrl.text,
                  courriel: _courrielCtrl.text,
                  adresse: _adresseCtrl.text,
                  ville: _villeCtrl.text,
                  codePostal: _codePostalCtrl.text,
                  description: _descriptionCtrl.text,
                  services: _servicesCtrl.text,
                  note: _noteCtrl.text,
                );

                Navigator.pop(context, r);
              }
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Nom obligatoire" : null,
              ),
              TextFormField(
                controller: _compagnieCtrl,
                decoration: const InputDecoration(labelText: "Compagnie"),
              ),
              TextFormField(
                controller: _tauxCtrl,
                decoration: const InputDecoration(labelText: "Taux horaire"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _telCtrl,
                decoration: const InputDecoration(labelText: "Téléphone"),
              ),
              TextFormField(
                controller: _faxCtrl,
                decoration: const InputDecoration(labelText: "Fax"),
              ),
              TextFormField(
                controller: _courrielCtrl,
                decoration: const InputDecoration(labelText: "Courriel"),
              ),
              TextFormField(
                controller: _adresseCtrl,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
              TextFormField(
                controller: _villeCtrl,
                decoration: const InputDecoration(labelText: "Ville"),
              ),
              TextFormField(
                controller: _codePostalCtrl,
                decoration: const InputDecoration(labelText: "Code postal"),
              ),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _servicesCtrl,
                decoration: const InputDecoration(labelText: "Services"),
                maxLines: 2,
              ),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: "Note"),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}