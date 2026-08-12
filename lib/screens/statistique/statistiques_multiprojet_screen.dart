// -----------------------------------------------------------------------------
// CHEMIN : lib/screens/statistique/statistiques_multiprojet_screen.dart
// -----------------------------------------------------------------------------
// Statistiques multiprojet par domaine (A à E)
// Affiche uniquement les pourcentages, dans une période donnée
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../api/statistiques_api.dart';
import '../../models/domaines.dart';

class StatistiquesMultiprojetScreen extends StatefulWidget {
  const StatistiquesMultiprojetScreen({super.key});

  @override
  State<StatistiquesMultiprojetScreen> createState() =>
      _StatistiquesMultiprojetScreenState();
}

class _StatistiquesMultiprojetScreenState
    extends State<StatistiquesMultiprojetScreen> {
  DateTime _debut = DateTime.now().subtract(const Duration(days: 30));
  DateTime _fin = DateTime.now();

  Map<String, double>? _stats;
  bool _chargement = false;

  // ---------------------------------------------------------------------------
  // CHARGER LES STATISTIQUES
  // ---------------------------------------------------------------------------
  Future<void> _charger() async {
    setState(() => _chargement = true);

    final data = await StatistiquesApi.getStatsMultiprojetDomaine(
      _debut,
      _fin,
    );

    setState(() {
      _stats = data;
      _chargement = false;
    });
  }

  // ---------------------------------------------------------------------------
  // SÉLECTEUR DE DATE
  // ---------------------------------------------------------------------------
  Future<void> _choisirDate(bool debut) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: debut ? _debut : _fin,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (debut) {
          _debut = picked;
        } else {
          _fin = picked;
        }
      });
    }
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques multiprojet"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sélecteurs de dates
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _choisirDate(true),
                    child: Text("Début : ${_debut.toString().split(' ')[0]}"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _choisirDate(false),
                    child: Text("Fin : ${_fin.toString().split(' ')[0]}"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _charger,
              child: const Text("Charger"),
            ),

            const SizedBox(height: 16),

            if (_chargement) const LinearProgressIndicator(),

            if (_stats != null)
              Expanded(
                child: ListView(
                  children: domaines.entries.map((entry) {
                    final code = entry.key;
                    final nom = entry.value;
                    final pourcentage = _stats![code] ?? 0.0;

                    return ListTile(
                      title: Text(nom),
                      trailing: Text("${pourcentage.toStringAsFixed(1)} %"),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}