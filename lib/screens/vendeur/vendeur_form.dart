// lib/screens/vendeur/vendeur_form.dart
//
// FORMULAIRE : Vendeur (version SSC1)
// -----------------------------------
// - Ajouter / Modifier
// - Champs en ordre SQL
// - Validations simples
// - Boutons Enregistrer / Annuler (Supprimer retiré)
// -----------------------------------

import 'package:flutter/material.dart';
import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';

class VendeurForm extends StatefulWidget {
  final Vendeur? vendeur;

  const VendeurForm({super.key, this.vendeur});

  @override
  State<VendeurForm> createState() => _VendeurFormState();
}

class _VendeurFormState extends State<VendeurForm> {
  final _service = VendeurService();

  final _nomCtrl = TextEditingController();
  final _adresseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _provCtrl = TextEditingController();
  final _codePostalCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _faxCtrl = TextEditingController();
  final _courrielCtrl = TextEditingController();
  final _siteCtrl = TextEditingController();

  bool _showErrors = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    if (widget.vendeur != null) {
      final v = widget.vendeur!;
      _nomCtrl.text = v.nom;
      _adresseCtrl.text = v.adresse ?? "";
      _villeCtrl.text = v.ville ?? "";
      _provCtrl.text = v.prov ?? "";
      _codePostalCtrl.text = v.codePostal ?? "";
      _paysCtrl.text = v.pays ?? "";
      _telCtrl.text = v.telephone ?? "";
      _faxCtrl.text = v.fax ?? "";
      _courrielCtrl.text = v.courriel ?? "";
      _siteCtrl.text = v.siteUrl ?? "";
    }
  }

  Map<String, String?> _validate() {
    final errors = <String, String?>{};
    if (_nomCtrl.text.trim().isEmpty) {
      errors['nom'] = "Nom obligatoire";
    }
    return errors;
  }

  Future<void> _save() async {
    final errors = _validate();
    if (errors.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    setState(() => _loading = true);

    try {
      Vendeur v = Vendeur(
        id: widget.vendeur?.id,
        nom: _nomCtrl.text.trim(),
        adresse: _adresseCtrl.text.trim(),
        ville: _villeCtrl.text.trim(),
        prov: _provCtrl.text.trim(),
        codePostal: _codePostalCtrl.text.trim(),
        pays: _paysCtrl.text.trim(),
        telephone: _telCtrl.text.trim(),
        fax: _faxCtrl.text.trim(),
        courriel: _courrielCtrl.text.trim(),
        siteUrl: _siteCtrl.text.trim(),
      );

      if (v.id == null) {
        v = await _service.create(v);
      } else {
        v = await _service.update(v);
      }

      if (!mounted) return;
      Navigator.pop(context, v);
    } catch (e) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Erreur"),
          content: Text("Impossible d'enregistrer le vendeur.\n$e"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final errors = _showErrors ? _validate() : {};

    return SizedBox(
      width: 420,
      child: Column(
        children: [
          // HEADER
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              widget.vendeur == null ? "Ajouter vendeur" : "Modifier vendeur",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // CONTENU
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nomCtrl,
                    decoration: InputDecoration(
                      labelText: "Nom",
                      errorText: errors['nom'],
                    ),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),
                  TextField(
                    controller: _adresseCtrl,
                    decoration: const InputDecoration(labelText: "Adresse"),
                  ),
                  TextField(
                    controller: _villeCtrl,
                    decoration: const InputDecoration(labelText: "Ville"),
                  ),
                  TextField(
                    controller: _provCtrl,
                    decoration: const InputDecoration(labelText: "Province"),
                  ),
                  TextField(
                    controller: _codePostalCtrl,
                    decoration: const InputDecoration(labelText: "Code postal"),
                  ),
                  TextField(
                    controller: _paysCtrl,
                    decoration: const InputDecoration(labelText: "Pays"),
                  ),
                  TextField(
                    controller: _telCtrl,
                    decoration: const InputDecoration(labelText: "Téléphone"),
                  ),
                  TextField(
                    controller: _faxCtrl,
                    decoration: const InputDecoration(labelText: "Fax"),
                  ),
                  TextField(
                    controller: _courrielCtrl,
                    decoration: const InputDecoration(labelText: "Courriel"),
                  ),
                  TextField(
                    controller: _siteCtrl,
                    decoration: const InputDecoration(labelText: "Site Web"),
                  ),
                ],
              ),
            ),
          ),

          // BOUTONS (Supprimer retiré)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Enregistrer à gauche
                ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: const Text("Enregistrer"),
                ),

                // Annuler à droite
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text("Annuler"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
