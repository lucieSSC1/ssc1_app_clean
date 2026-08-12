// ssc1_app/lib/screens/film/film_list.dart
//
// Liste : Films (module Loisir - SSC1)
// ------------------------------------
// Affiche tous les films.
//
// Actions :
// - Ouvrir le détail
// - Ajouter un film

import 'package:flutter/material.dart';

import '../../models/film_model.dart';
import '../../services/film_service.dart';

import 'film_detail.dart';
import 'film_form.dart';

class FilmList extends StatefulWidget {
  const FilmList({super.key});

  @override
  State<FilmList> createState() => _FilmListState();
}

class _FilmListState extends State<FilmList> {
  final _service = FilmService();

  List<Film> _liste = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // Charger la liste
  // ------------------------------------------------------------
  Future<void> _charger() async {
    setState(() => _loading = true);

    try {
      final data = await _service.getAll();

      // Tri alphabétique par titre
      data.sort((a, b) {
        final t1 = a.titre?.toLowerCase() ?? "";
        final t2 = b.titre?.toLowerCase() ?? "";
        return t1.compareTo(t2);
      });

      setState(() {
        _liste = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint("Erreur chargement films : $e");
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Films"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Nouveau film",
            onPressed: () async {
              final created = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FilmForm(),
                ),
              );

              if (created == true) {
                _charger();
              }
            },
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _liste.isEmpty
              ? const Center(child: Text("Aucun film"))
              : ListView.builder(
                  itemCount: _liste.length,
                  itemBuilder: (context, index) {
                    final f = _liste[index];

                    return ListTile(
                      title: Text(f.titre ?? "(Sans titre)"),
                      subtitle: Text(f.realisateur ?? "—"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FilmDetail(film: f),
                          ),
                        );

                        if (updated == true) {
                          _charger();
                        }
                      },
                    );
                  },
                ),
    );
  }
}