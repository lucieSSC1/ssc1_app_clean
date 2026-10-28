// lib/screens/vendeur/vendeur_list.dart
//
// LISTE : Vendeurs (version SSC1)
// -------------------------------
// - Une seule liste pour Sélectionner et Gérer
// - Bouton +Ajouter
// - Mode Sélectionner : clic → retourne vendeur
// - Mode Gérer : clic → sélectionne (surbrillance)
// - Mode Gérer : Modifier / Supprimer à droite
// - Pas de fiche statique
// - Largeur 420 px
// -------------------------------

import 'package:flutter/material.dart';

import '../../models/vendeur_model.dart';
import '../../services/vendeur_service.dart';

import 'vendeur_form.dart';

class VendeurList extends StatefulWidget {
  final bool selectionMode; // true = Sélectionner, false = Gérer

  const VendeurList({super.key, this.selectionMode = false});

  @override
  State<VendeurList> createState() => _VendeurListState();
}

class _VendeurListState extends State<VendeurList> {
  final _service = VendeurService();

  List<Vendeur> _liste = [];
  bool _loading = true;

  int? _selectedId; // vendeur sélectionné en mode Gérer

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);

    try {
      _liste = await _service.getAll();
    } catch (_) {
      _liste = [];
    }

    setState(() => _loading = false);
  }

  Future<void> _ajouter() async {
    final result = await showDialog<Vendeur?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: SizedBox(width: 420, child: const VendeurForm(vendeur: null)),
      ),
    );

    if (result != null) {
      await _charger();
    }
  }

  Future<void> _modifier(Vendeur v) async {
    final result = await showDialog<Vendeur?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        child: SizedBox(width: 420, child: VendeurForm(vendeur: v)),
      ),
    );

    if (result != null) {
      await _charger();
    }
  }

  Future<void> _supprimer(Vendeur v) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer vendeur"),
        content: Text("Supprimer ${v.nom} ?"),
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
      await _service.delete(v.id!);
      await _charger();
      setState(() => _selectedId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? "Sélectionner vendeur" : "Gérer vendeurs",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Ajouter vendeur",
            onPressed: _ajouter,
          ),
        ],
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _liste.isEmpty
              ? const Center(
                  child: Text("Aucun vendeur", style: TextStyle(fontSize: 18)),
                )
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (_, index) {
                    final v = _liste[index];
                    final isSelected = v.id == _selectedId;

                    return Card(
                      color: (!widget.selectionMode && isSelected)
                          ? Colors.grey.shade300
                          : null,
                      child: ListTile(
                        title: Text(v.nom),
                        subtitle: Text(v.ville ?? "-"),

                        // -------------------------------
                        // MODE SÉLECTIONNER
                        // -------------------------------
                        onTap: () {
                          if (widget.selectionMode) {
                            Navigator.pop(context, v);
                            return;
                          }

                          // -------------------------------
                          // MODE GÉRER → sélectionne l’enregistrement
                          // -------------------------------
                          setState(() => _selectedId = v.id);
                        },

                        // -------------------------------
                        // MODE GÉRER → Modifier / Supprimer
                        // -------------------------------
                        trailing: widget.selectionMode
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    tooltip: "Modifier",
                                    onPressed: () => _modifier(v),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: "Supprimer",
                                    onPressed: () => _supprimer(v),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
