/* ---------------------------------------------------------------------------
   CHEMIN : lib/screens/statistiques/statistiques_multiprojet_screen.dart
   ÉCRAN : Statistiques multiprojet (Structure 4)

   LOGIQUE :
     - On regarde TOUTES les JOURNÉES travaillées durant la période
     - On regroupe par DOMAINE du PROJET
     - On calcule les pourcentages A–E
     - On affiche les textes officiels des domaines

   DOMAINES :
     A = Revenu
     B = Perfectionnement
     C = Développement personnel
     D = Loisir / Recherche
     E = Vie

   API :
     GET /statistiques/multiprojet/domaine?debut=YYYY-MM-DD&fin=YYYY-MM-DD
   --------------------------------------------------------------------------- */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../api/statistiques_api.dart';

class StatistiquesMultiprojetScreen extends StatefulWidget {
  const StatistiquesMultiprojetScreen({super.key});

  @override
  State<StatistiquesMultiprojetScreen> createState() =>
      _StatistiquesMultiprojetScreenState();
}

class _StatistiquesMultiprojetScreenState
    extends State<StatistiquesMultiprojetScreen> {
  DateTime debut = DateTime.now().subtract(const Duration(days: 30));
  DateTime fin = DateTime.now();

  Map<String, double>? stats;
  bool loading = false;

  String format(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  final Map<String, String> domaines = {
    "A": "Revenu",
    "B": "Perfectionnement",
    "C": "Développement personnel",
    "D": "Loisir / Recherche",
    "E": "Vie",
  };

  Future<void> chargerStats() async {
    setState(() => loading = true);

    final data = await StatistiquesApi.getStatsMultiprojetDomaine(debut, fin);

    setState(() {
      stats = data;
      loading = false;
    });
  }

  Future<void> choisirDateDebut() async {
    final d = await showDatePicker(
      context: context,
      initialDate: debut,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => debut = d);
      chargerStats();
    }
  }

  Future<void> choisirDateFin() async {
    final d = await showDatePicker(
      context: context,
      initialDate: fin,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      setState(() => fin = d);
      chargerStats();
    }
  }

  @override
  void initState() {
    super.initState();
    chargerStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques multiprojet"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------------------------------------------------
            // SÉLECTEURS DE DATES
            // ---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Début
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Début"),
                    TextButton(
                      onPressed: choisirDateDebut,
                      child: Text(format(debut)),
                    ),
                  ],
                ),

                // Fin
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Fin"),
                    TextButton(
                      onPressed: choisirDateFin,
                      child: Text(format(fin)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------------------------------------------------
            // RÉSULTATS
            // ---------------------------------------------------------
            if (loading)
              const CircularProgressIndicator()
            else if (stats == null)
              const Text("Aucune donnée.")
            else
              Expanded(
                child: ListView(
                  children: [
                    _ligne("A", domaines["A"]!, stats!["A"] ?? 0),
                    _ligne("B", domaines["B"]!, stats!["B"] ?? 0),
                    _ligne("C", domaines["C"]!, stats!["C"] ?? 0),
                    _ligne("D", domaines["D"]!, stats!["D"] ?? 0),
                    _ligne("E", domaines["E"]!, stats!["E"] ?? 0),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _ligne(String code, String texte, double valeur) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text("$code — $texte"),
        trailing: Text("${valeur.toStringAsFixed(1)} %"),
      ),
    );
  }
}