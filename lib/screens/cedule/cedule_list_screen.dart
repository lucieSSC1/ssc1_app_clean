/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/cedule/cedule_list_screen.dart
   STRUCTURE 4 — Liste des cédules

   Affiche :
     - activ_code
     - activ_nom
     - date (DD-MM-YYYY)
     - durée planifiée
     - statut terminé

   Actions :
     - Modifier
     - Supprimer
     - Switch terminé
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/cedule_api.dart';
import '../../models/cedule_model.dart';

import 'cedule_edit_screen.dart';

class CeduleListScreen extends StatefulWidget {
  final int? activiteId; // null = toutes les cédules

  const CeduleListScreen({super.key, this.activiteId});

  @override
  State<CeduleListScreen> createState() => _CeduleListScreenState();
}

class _CeduleListScreenState extends State<CeduleListScreen> {
  List<CeduleModel> liste = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    setState(() => loading = true);

    if (widget.activiteId != null) {
      liste = await CeduleApi.getCedulesParActivite(widget.activiteId!);
    } else {
      liste = await CeduleApi.getCedules();
    }

    setState(() => loading = false);
  }

  Future<void> supprimer(int id) async {
    await CeduleApi.deleteCedule(id);
    charger();
  }

  Future<void> changerTerminee(CeduleModel c, bool value) async {
    await CeduleApi.setTerminee(c.id, value);
    charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cédules"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : liste.isEmpty
              ? const Center(child: Text("Aucune cédule."))
              : ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    final c = liste[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text("${c.activCode} — ${c.activNom}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date : ${c.date}"),
                            Text("Durée planifiée : ${c.dureePlanifiee} h"),
                          ],
                        ),

                        // -----------------------------------------------------
                        // BOUTONS À DROITE
                        // -----------------------------------------------------
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // -------------------------------------------------
                            // BOUTON MODIFIER
                            // -------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.edit),
                              tooltip: "Modifier",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CeduleEditScreen(cedule: c),
                                  ),
                                ).then((_) => charger());
                              },
                            ),

                            // -------------------------------------------------
                            // BOUTON SUPPRIMER
                            // -------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Supprimer",
                              onPressed: () => supprimer(c.id),
                            ),
                          ],
                        ),

                        // -----------------------------------------------------
                        // SWITCH TERMINÉE
                        // -----------------------------------------------------
                        leading: Switch(
                          value: c.terminee,
                          onChanged: (v) => changerTerminee(c, v),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}