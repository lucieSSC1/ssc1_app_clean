// lib/screens/biographie/vendeur_liste.dart

import 'package:flutter/material.dart';
import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';
import 'form_vendeur.dart';

class VendeurListe extends StatefulWidget {
  const VendeurListe({super.key});

  @override
  State<VendeurListe> createState() => _VendeurListeState();
}

class _VendeurListeState extends State<VendeurListe> {
  final _service = VendeurService();
  List<Vendeur> liste = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    try {
      final data = await _service.getAll();
      setState(() {
        liste = data;
        chargement = false;
      });
    } catch (e) {
      setState(() => chargement = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  Future<void> ouvrirFormulaire(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormVendeur(
          liste: liste,
          startIndex: index,
        ),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des vendeurs")),
      body: chargement
          ? const Center(child: CircularProgressIndicator())
          : liste.isEmpty
              ? const Center(child: Text("Aucun vendeur"))
              : ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (_, index) {
                    final v = liste[index];
                    return Card(
                      child: ListTile(
                        title: Text(v.nom),
                        subtitle: Text(v.ville ?? ""),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => ouvrirFormulaire(index),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => ouvrirFormulaire(-1),
      ),
    );
  }
}
