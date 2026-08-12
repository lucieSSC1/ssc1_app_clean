// -----------------------------------------------------------------------------
// FICHIER : lib/screens/projet/projet_fields.dart
// -----------------------------------------------------------------------------
// Champs du projet (ID, titre, dates, catégorie, domaine, objectif)
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'projet_controller.dart';

class ProjetFormFields extends StatelessWidget {
  const ProjetFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProjetController>(context);
    final projet = controller.projetActif;

    if (projet == null) {
      return const Padding(
        padding: EdgeInsets.all(12.0),
        child: Text(
          "Aucun projet sélectionné.",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          return Column(
            children: _buildFields(context, controller),
          );
        }

        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 3.5,
          physics: const NeverScrollableScrollPhysics(),
          children: _buildFields(context, controller),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // LISTE DES CHAMPS DU PROJET
  // ---------------------------------------------------------------------------
  List<Widget> _buildFields(
    BuildContext context,
    ProjetController controller,
  ) {
    final projet = controller.projetActif!;

    return [
      // ID (lecture seule)
      TextFormField(
        initialValue: projet.id.toString(),
        decoration: const InputDecoration(
          labelText: "ID",
          border: OutlineInputBorder(),
        ),
        enabled: false,
      ),

      // TITRE
      TextFormField(
        initialValue: projet.titre,
        decoration: const InputDecoration(
          labelText: "Titre",
          border: OutlineInputBorder(),
        ),
        onChanged: controller.mettreAJourTitre,
      ),

      // DATE DE DÉBUT (glob_info)
      TextFormField(
        initialValue: projet.debut ?? "",
        decoration: const InputDecoration(
          labelText: "Début",
          border: OutlineInputBorder(),
        ),
        onChanged: controller.mettreAJourDebut,
      ),

      // DATE DE FIN (glob_info)
      TextFormField(
        initialValue: projet.fin ?? "",
        decoration: const InputDecoration(
          labelText: "Fin",
          border: OutlineInputBorder(),
        ),
        onChanged: controller.mettreAJourFin,
      ),

      // CATÉGORIE (ID)
      TextFormField(
        initialValue: projet.categorieId?.toString() ?? "",
        decoration: const InputDecoration(
          labelText: "Catégorie (ID)",
          border: OutlineInputBorder(),
        ),
        onChanged: controller.mettreAJourCategorieId,
      ),

      // DOMAINE (5 valeurs fixes, hardcodées)
      DropdownButtonFormField<int>(
        value: projet.domaineId,
        decoration: const InputDecoration(
          labelText: "Domaine",
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 1, child: Text("A – Revenu")),
          DropdownMenuItem(value: 2, child: Text("B – Perfectionnement")),
          DropdownMenuItem(value: 3, child: Text("C – Développement personnel")),
          DropdownMenuItem(value: 4, child: Text("D – Loisir / Recherche")),
          DropdownMenuItem(value: 5, child: Text("E – Vie")),
        ],
        onChanged: controller.mettreAJourDomaineId,
      ),

      // OBJECTIF
      TextFormField(
        initialValue: projet.objectif,
        decoration: const InputDecoration(
          labelText: "Objectif",
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        onChanged: controller.mettreAJourObjectif,
      ),
    ];
  }
}