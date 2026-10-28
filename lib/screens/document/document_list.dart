// ============================================================
// FICHIER : lib/screens/document/document_list.dart
// Version SSC1 — Liste Documents
// ============================================================

import 'package:flutter/material.dart';

import '../../models/document_model.dart';
import '../../models/global_info_model.dart';

import '../../services/document_service.dart';
import '../../services/global_info_service.dart';

import 'document_detail.dart';
import 'document_form.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  final _service = DocumentService();
  final _globService = GlobalInfoService();

  final _idCtrl = TextEditingController();

  List<DocumentModel> _items = [];
  List<DocumentModel> _currentList = [];

  Map<int, GlobalInfo?> _globMap = {};

  String? _critereActuel = "Tous";

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    _loading = true;

    _items = await _service.getAllDocuments();

    _globMap.clear();

    for (var doc in _items) {
      if (doc.globId != null) {
        final info = await _globService.getById(doc.globId!);

        _globMap[doc.globId!] = info;
      }
    }

    _currentList = List.from(_items);

    _critereActuel = "Tous";

    setState(() {
      _loading = false;
    });
  }

  Future<void> _popup(String msg) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(msg),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";

    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _searchById() async {
    final txt = _idCtrl.text.trim();

    if (txt.isEmpty) return;

    final id = int.tryParse(txt);

    if (id == null) {
      _popup("ID invalide");
      return;
    }

    final doc = await _service.getDocumentById(id);

    if (doc == null) {
      _popup("Aucun résultat");
      return;
    }

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DocumentDetail(liste: [doc], index: 0, critere: null),
      ),
    );

    if (updated == true) {
      await _charger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Documents"),
        actions: [
          IconButton(
            tooltip: "Ajouter",
            icon: const Icon(Icons.add),
            onPressed: () async {
              final updated = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (_) => Dialog(
                  child: SizedBox(width: 420, child: const DocumentForm()),
                ),
              );

              if (updated == true) {
                await _charger();
              }
            },
          ),

          IconButton(
            tooltip: "Tout",
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _idCtrl.clear();
              _charger();
            },
          ),

          SizedBox(
            width: 50,
            child: TextField(
              controller: _idCtrl,
              maxLength: 4,
              decoration: const InputDecoration(
                counterText: "",
                hintText: "ID",
              ),
              keyboardType: TextInputType.number,
            ),
          ),

          IconButton(
            tooltip: "Recherche ID",
            icon: const Icon(Icons.search),
            onPressed: _searchById,
          ),
        ],
      ),

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _currentList.isEmpty
          ? const Center(child: Text("Aucun document"))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 40,
                        child: Text("ID", textAlign: TextAlign.right),
                      ),
                      SizedBox(width: 8),

                      SizedBox(width: 80, child: Text("Début")),
                      SizedBox(width: 8),

                      SizedBox(width: 80, child: Text("Fin")),
                      SizedBox(width: 8),

                      SizedBox(width: 40, child: Text("Type")),
                      SizedBox(width: 8),

                      Expanded(child: Text("Titre")),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _currentList.length,
                    itemBuilder: (_, i) {
                      final doc = _currentList[i];

                      final info = _globMap[doc.globId];

                      return InkWell(
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DocumentDetail(
                                liste: [doc],
                                index: 0,
                                critere: null,
                              ),
                            ),
                          );

                          if (updated == true) {
                            await _charger();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 40,
                                child: Text(
                                  "${doc.id}",
                                  textAlign: TextAlign.right,
                                ),
                              ),

                              const SizedBox(width: 8),

                              SizedBox(
                                width: 80,
                                child: Text(_fmt(info?.debut)),
                              ),

                              const SizedBox(width: 8),

                              SizedBox(width: 80, child: Text(_fmt(info?.fin))),

                              const SizedBox(width: 8),

                              SizedBox(
                                width: 40,
                                child: Text(info?.type ?? "DOC"),
                              ),

                              const SizedBox(width: 8),

                              Expanded(
                                child: Text(
                                  doc.titre,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Quitter"),
        ),
      ),
    );
  }
}
