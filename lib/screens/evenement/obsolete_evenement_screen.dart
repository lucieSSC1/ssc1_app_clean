// ============================================================
// FICHIER : ssc1_app/lib/screens/evenement/evenement_screen.dart
// Écran : Événements (Supabase)
// ============================================================

import 'package:flutter/material.dart';
import '../../models/evenement_model.dart';
import '../../services/evenement_service.dart';

class EvenementScreen extends StatefulWidget {
  const EvenementScreen({super.key});

  @override
  State<EvenementScreen> createState() => _EvenementScreenState();
}

class _EvenementScreenState extends State<EvenementScreen> {
  final EvenementService _service = EvenementService();
  List<Evenement> _evenements = [];
  bool _loading = true;

  // Recherche
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    setState(() => _loading = true);

    final data = await _service.getAll();

    setState(() {
      _evenements = data;
      _loading = false;
    });
  }

  Future<void> _search() async {
    final query = _searchCtrl.text.trim();

    if (query.isEmpty) {
      _loadEvenements();
      return;
    }

    final data = await _service.searchByTitre(query);

    setState(() {
      _evenements = data;
    });
  }

  // ------------------------------------------------------------
  // UI : Ajout rapide
  // ------------------------------------------------------------
  Future<void> _addEvenement() async {
    final evt = Evenement(
      nom: "Nouvel événement",
      description: "",
      categorie: null,
      glob_id: null,
      motCle1: "",
      motCle2: "",
      motCle3: "",
    );

    await _service.create(evt);
    _loadEvenements();
  }

  // ------------------------------------------------------------
  // UI : Suppression
  // ------------------------------------------------------------
  Future<void> _delete(int id) async {
    await _service.delete(id);
    _loadEvenements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Événements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvenements,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addEvenement,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // ------------------------------------------------------------
          // Barre de recherche
          // ------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: "Recherche par nom",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------
          // Liste des événements
          // ------------------------------------------------------------
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _evenements.length,
                    itemBuilder: (context, index) {
                      final evt = _evenements[index];

                      return Card(
                        child: ListTile(
                          title: Text(evt.nom ?? "(sans nom)"),
                          subtitle: Text(evt.description ?? ""),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(evt.id!),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
