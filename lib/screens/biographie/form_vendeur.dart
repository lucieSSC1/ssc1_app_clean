// lib/screens/biographie/form_vendeur.dart

import 'package:flutter/material.dart';
import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';

class FormVendeur extends StatefulWidget {
  final List<Vendeur> liste;
  final int startIndex;

  const FormVendeur({
    super.key,
    required this.liste,
    required this.startIndex,
  });

  @override
  State<FormVendeur> createState() => _FormVendeurState();
}

class _FormVendeurState extends State<FormVendeur> {
  late int currentIndex;
  bool modeCreation = false;

  final nomCtrl = TextEditingController();
  final adresseCtrl = TextEditingController();
  final villeCtrl = TextEditingController();
  final provCtrl = TextEditingController();
  final codePostalCtrl = TextEditingController();
  final paysCtrl = TextEditingController();
  final telephoneCtrl = TextEditingController();
  final faxCtrl = TextEditingController();
  final courrielCtrl = TextEditingController();
  final siteCtrl = TextEditingController();

  final _service = VendeurService();

  @override
  void initState() {
    super.initState();

    modeCreation = widget.startIndex == -1;
    currentIndex = modeCreation ? 0 : widget.startIndex;

    charger();
  }

  void charger() {
    if (modeCreation || widget.liste.isEmpty) {
      nomCtrl.text = "";
      adresseCtrl.text = "";
      villeCtrl.text = "";
      provCtrl.text = "";
      codePostalCtrl.text = "";
      paysCtrl.text = "";
      telephoneCtrl.text = "";
      faxCtrl.text = "";
      courrielCtrl.text = "";
      siteCtrl.text = "";
      return;
    }

    final v = widget.liste[currentIndex];

    nomCtrl.text = v.nom;
    adresseCtrl.text = v.adresse ?? "";
    villeCtrl.text = v.ville ?? "";
    provCtrl.text = v.prov ?? "";
    codePostalCtrl.text = v.codePostal ?? "";
    paysCtrl.text = v.pays ?? "";
    telephoneCtrl.text = v.telephone ?? "";
    faxCtrl.text = v.fax ?? "";
    courrielCtrl.text = v.courriel ?? "";
    siteCtrl.text = v.siteUrl ?? "";
  }

  Future<void> enregistrer() async {
    final v = Vendeur(
      id: modeCreation ? null : widget.liste[currentIndex].id,
      nom: nomCtrl.text,
      adresse: adresseCtrl.text,
      ville: villeCtrl.text,
      prov: provCtrl.text,
      codePostal: codePostalCtrl.text,
      pays: paysCtrl.text,
      telephone: telephoneCtrl.text,
      fax: faxCtrl.text,
      courriel: courrielCtrl.text,
      siteUrl: siteCtrl.text,
    );

    if (modeCreation) {
      final created = await _service.create(v);
      widget.liste.add(created);
      currentIndex = widget.liste.length - 1;
      modeCreation = false;
    } else {
      final updated = await _service.update(v);
      widget.liste[currentIndex] = updated;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vendeur enregistré")),
    );

    setState(() {});
  }

  Future<void> supprimer() async {
    if (modeCreation) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: const Text("Voulez-vous vraiment supprimer ce vendeur ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annuler")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Supprimer")),
        ],
      ),
    );

    if (ok != true) return;

    final id = widget.liste[currentIndex].id!;
    await _service.delete(id);

    widget.liste.removeAt(currentIndex);

    if (widget.liste.isEmpty) {
      modeCreation = true;
      charger();
      return;
    }

    if (currentIndex >= widget.liste.length) {
      currentIndex = widget.liste.length - 1;
    }

    charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(modeCreation ? "Nouveau vendeur" : "Vendeur"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!modeCreation)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = 0;
                          charger();
                        });
                      },
                      icon: const Icon(Icons.first_page)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (currentIndex > 0) currentIndex--;
                          charger();
                        });
                      },
                      icon: const Icon(Icons.navigate_before)),
                  Text(" ${currentIndex + 1} / ${widget.liste.length} "),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (currentIndex < widget.liste.length - 1) {
                            currentIndex++;
                          }
                          charger();
                        });
                      },
                      icon: const Icon(Icons.navigate_next)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentIndex = widget.liste.length - 1;
                          charger();
                        });
                      },
                      icon: const Icon(Icons.last_page)),
                ],
              ),

            const SizedBox(height: 20),

            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: adresseCtrl, decoration: const InputDecoration(labelText: "Adresse")),
            TextField(controller: villeCtrl, decoration: const InputDecoration(labelText: "Ville")),
            TextField(controller: provCtrl, decoration: const InputDecoration(labelText: "Province")),
            TextField(controller: codePostalCtrl, decoration: const InputDecoration(labelText: "Code postal")),
            TextField(controller: paysCtrl, decoration: const InputDecoration(labelText: "Pays")),
            TextField(controller: telephoneCtrl, decoration: const InputDecoration(labelText: "Téléphone")),
            TextField(controller: faxCtrl, decoration: const InputDecoration(labelText: "Fax")),
            TextField(controller: courrielCtrl, decoration: const InputDecoration(labelText: "Courriel")),
            TextField(controller: siteCtrl, decoration: const InputDecoration(labelText: "Site web")),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: enregistrer, child: const Text("Enregistrer")),
                if (!modeCreation)
                  ElevatedButton(
                    onPressed: supprimer,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Supprimer"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
