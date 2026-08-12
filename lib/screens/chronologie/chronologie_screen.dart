// Fichier : lib/screens/chronologie/chronologie_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class ChronologieScreen extends StatefulWidget {
  @override
  _ChronologieScreenState createState() => _ChronologieScreenState();
}

class _ChronologieScreenState extends State<ChronologieScreen> {
  DateTime? dateDebut;
  DateTime? dateFin;

  // Liste officielle des TYPES SSC1
  final Map<String, bool> types = {
    "EVE": false,
    "ACQU": false,
    "RES": false,
    "DEMA": false,
    "CHAN": false,
    "FILM": false,
    "RECT": false,
    "ECRI": false,
    "REF": false,
    "DOC": false,
    "PROJ": false,
    "COUR": false,
    "EMPL": false,
    "PROG": false,
  };

  List<dynamic> resultats = [];

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          dateDebut = picked;
        } else {
          dateFin = picked;
        }
      });
    }
  }

  Future<void> rechercher() async {
    if (dateDebut == null || dateFin == null) return;

    final selectedTypes =
        types.entries.where((e) => e.value).map((e) => e.key).toList();

    final data = {
      "date_debut": DateFormat("yyyy-MM-dd").format(dateDebut!),
      "date_fin": DateFormat("yyyy-MM-dd").format(dateFin!),
      "types": selectedTypes
    };

    final response = await ApiService.post("/chronologie/rechercher", data);

    setState(() {
      resultats = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Générateur de chronologie")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sélecteurs de dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(dateDebut == null
                      ? "Date début"
                      : DateFormat("yyyy-MM-dd").format(dateDebut!)),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(dateFin == null
                      ? "Date fin"
                      : DateFormat("yyyy-MM-dd").format(dateFin!)),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Liste des types
            Expanded(
              child: ListView(
                children: types.keys.map((t) {
                  return CheckboxListTile(
                    title: Text(t),
                    value: types[t],
                    onChanged: (v) {
                      setState(() {
                        types[t] = v!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: rechercher,
              child: Text("Rechercher"),
            ),

            SizedBox(height: 20),

            // Résultats
            Expanded(
              child: ListView.builder(
                itemCount: resultats.length,
                itemBuilder: (context, index) {
                  final r = resultats[index];
                  return ListTile(
                    title: Text(
                        "${r['debut']}   ${r['fin']}   ${r['type']}   ${r['nom']}"),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                ElevatedButton(
  onPressed: () async {
    final pdfData = await ChronologiePdf.generate(
      resultats,
      "Chronologie du ${DateFormat("dd-MM-yyyy").format(dateDebut!)} "
      "au ${DateFormat("dd-MM-yyyy").format(dateFin!)}",
    );

    // Ouvre l’écran d’affichage PDF
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewScreen(pdfData),
      ),
    );
  },
  child: Text("Exporter PDF"),
),
              },
              child: Text("Exporter PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
