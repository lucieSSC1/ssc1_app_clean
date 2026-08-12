/* -----------------------------------------------------------------------------
   FICHIER : lib/screens/planification/planification_list_screen.dart
   STRUCTURE 4 — Liste des planifications

   Affiche :
     - activ_code
     - activ_nom
     - description
     - statut (terminée / non terminée)

   Actions :
     - Céduler
     - Modifier
     - Supprimer
   ----------------------------------------------------------------------------- */

import 'package:flutter/material.dart';

import '../../api/planification_api.dart';
import '../../models/planification_model.dart';

import '../cedule/cedule_add_screen.dart';
import 'planification_edit_screen.dart';

class PlanificationListScreen extends StatefulWidget {
  final int? activiteId; // null = toutes les planifications

  const PlanificationListScreen({super.key, this.activiteId});

  @override
  State<PlanificationListScreen> createState() =>
      _PlanificationListScreenState();
}

class _PlanificationListScreenState extends State<PlanificationListScreen> {
  List<PlanificationModel> liste = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    charger();
  }

  Future<void> charger() async {
    setState(() => loading = true);

    if (widget.activiteId != null) {
      liste = await PlanificationApi.getPlanificationsParActivite(
          widget.activiteId!);
    } else {
      liste = await PlanificationApi.getPlanifications();
    }

    setState(() => loading = false);
  }

  Future<void> supprimer(int id) async {
    await PlanificationApi.deletePlanification(id);
    charger();
  }

  Future<void> changerTerminee(PlanificationModel p, bool value) async {
    await PlanificationApi.setTerminee(p.id, value);
    charger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planification"),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : liste.isEmpty
              ? const Center(child: Text("Aucune planification."))
              : ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    final p = liste[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text("${p.activCode} — ${p.activNom}"),
                        subtitle: Text(p.description ?? "(Aucune description)"),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // -------------------------------------------------
                            // BOUTON CÉDULER
                            // -------------------------------------------------
                            IconButton(
                              icon: const Icon(Icons.calendar_month),
                              tooltip: "Céduler",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CeduleAddScreen(
                                      activId: p.activId,
                                      activCode: p.activCode,
                                      activNom: p.activNom,
                                    ),
                                  ),
                                );
                              },
                            ),

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
                                        PlanificationEditScreen(planif: p),
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
                              onPressed: () => supprimer(p.id),
                            ),
                          ],
                        ),

                        // -----------------------------------------------------
                        // SWITCH TERMINÉE
                        // -----------------------------------------------------
                        leading: Switch(
                          value: p.terminee,
                          onChanged: (v) => changerTerminee(p, v),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}