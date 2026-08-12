// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/projet_selector.dart
// -----------------------------------------------------------------------------
// Sélecteur de projet (liste déroulante)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'projet_controller.dart';

class ProjetSelector extends StatefulWidget {
  const ProjetSelector({super.key});

  @override
  State<ProjetSelector> createState() => _ProjetSelectorState();
}

class _ProjetSelectorState extends State<ProjetSelector> {
  List<ProjetModel> _projetsDisponibles = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerListeProjets();
  }

  // ---------------------------------------------------------------------------
  // CHARGEMENT DE LA LISTE DES PROJETS (à remplacer par ton API)
  // ---------------------------------------------------------------------------
  Future<void> _chargerListeProjets() async {
    try {
      setState(() {
        _chargement = true;
        _erreur = null;
      });

      await Future.delayed(const Duration(milliseconds: 300));

      _projetsDisponibles = [
        ProjetModel(id: 1, titre: "Projet Alpha"),
        ProjetModel(id: 2, titre: "Projet Beta"),
        ProjetModel(id: 3, titre: "Projet Gamma"),
      ];
    } catch (e) {
      _erreur = "Impossible de charger la liste des projets.";
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProjetController>(context);

    // CHARGEMENT
    if (_chargement) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: LinearProgressIndicator(),
      );
    }

    // ERREUR
    if (_erreur != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _erreur!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    // LISTE VIDE
    if (_projetsDisponibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Aucun projet disponible."),
      );
    }

    // LISTE DÉROULANTE
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<ProjetModel>(
        decoration: const InputDecoration(
          labelText: "Projet",
          border: OutlineInputBorder(),
        ),

        value: controller.projetActif,

        items: _projetsDisponibles.map((projet) {
          return DropdownMenuItem(
            value: projet,
            child: Text(projet.titre),
          );
        }).toList(),

        onChanged: (projet) {
          if (projet != null) {
            controller.selectionnerProjet(projet);
          }
        },
      ),
    );
  }
}