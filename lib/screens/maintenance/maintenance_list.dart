// lib/screens/maintenance/maintenance_list.dart
//
// LISTE : Maintenance (version SSC1)
// ----------------------------------
// - Historique d'une acquisition
// - Tri chronologique (date)
// - Bouton +Ajouter (icone seulement)
// - Modifier / Supprimer sur chaque enregistrement
// - Une simple ligne séparatrice
// - Largeur 420 px
// ----------------------------------

import 'package:flutter/material.dart';

import '../../models/maintenance_model.dart';
import '../../services/maintenance_service.dart';

import 'maintenance_form.dart';

class MaintenanceList extends StatefulWidget {
  final int acquId;
  final String? acquisitionNom;

  const MaintenanceList({super.key, required this.acquId, this.acquisitionNom});

  @override
  State<MaintenanceList> createState() => _MaintenanceListState();
}

class _MaintenanceListState extends State<MaintenanceList> {
  final _service = MaintenanceService();

  List<MaintenanceModel> _liste = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);

    try {
      _liste = await _service.getByAcquisition(widget.acquId);
    } catch (_) {
      _liste = [];
    }

    setState(() => _loading = false);
  }

  String _fmtDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  String _fmtMontant(double? montant) {
    if (montant == null) return "-";

    return "${montant.toStringAsFixed(2)}\$";
  }

  Future<void> _ajouter() async {
    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: SizedBox(
          width: 420,
          child: MaintenanceForm(acquId: widget.acquId),
        ),
      ),
    );

    if (updated == true) {
      await _charger();
    }
  }

  Future<void> _modifier(MaintenanceModel maintenance) async {
    final updated = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: SizedBox(
          width: 420,
          child: MaintenanceForm(
            acquId: widget.acquId,
            maintenance: maintenance,
          ),
        ),
      ),
    );

    if (updated == true) {
      await _charger();
    }
  }

  Future<void> _supprimer(MaintenanceModel maintenance) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer maintenance"),
        content: Text(
          "Supprimer l'intervention du "
          "${_fmtDate(maintenance.date)} ?",
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Supprimer"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.delete(maintenance.id!);
      await _charger();
    }
  }

  Widget _ligne(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.acquisitionNom == null
              ? "Maintenance"
              : "Maintenance : ${widget.acquisitionNom}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Ajouter",
            onPressed: _ajouter,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _liste.isEmpty
          ? const Center(child: Text("Aucune maintenance"))
          : ListView.builder(
              itemCount: _liste.length,
              itemBuilder: (context, index) {
                final m = _liste[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _fmtDate(m.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: "Modifier",
                            onPressed: () => _modifier(m),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: "Supprimer",
                            onPressed: () => _supprimer(m),
                          ),
                        ],
                      ),

                      _ligne("À faire", m.aEffectuer ?? "-"),

                      _ligne("Réparateur", m.reparateur ?? "-"),

                      _ligne("Effectué", m.effectue ?? "-"),

                      _ligne("Durée", m.duree?.toString() ?? "-"),

                      _ligne("Pièces", _fmtMontant(m.pieces)),

                      _ligne("Coût", _fmtMontant(m.cout)),

                      _ligne("Facture", m.facture ?? "-"),

                      const SizedBox(height: 8),

                      const Divider(thickness: 1),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          child: const Text("Fermer"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
