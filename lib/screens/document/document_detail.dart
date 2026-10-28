// ============================================================
// FICHIER : lib/screens/document/document_detail.dart
// Version SSC1 — Fiche officielle Document
// ============================================================

import 'package:flutter/material.dart';

import '../../models/document_model.dart';
import '../../models/global_info_model.dart';

import '../../services/document_service.dart';
import '../../services/global_info_service.dart';
import '../../services/storage_service.dart';

import 'document_form.dart';

class DocumentDetail extends StatefulWidget {
  final List<DocumentModel> liste;
  final int index;
  final String? critere;

  const DocumentDetail({
    super.key,
    required this.liste,
    required this.index,
    this.critere,
  });

  @override
  State<DocumentDetail> createState() => _DocumentDetailState();
}

class _DocumentDetailState extends State<DocumentDetail> {
  final _docService = DocumentService();
  final _globService = GlobalInfoService();
  final _storageService = StorageService();

  GlobalInfo? _info;

  bool _loading = true;

  late int _pos;

  DocumentModel? _doc;

  @override
  void initState() {
    super.initState();

    _pos = widget.index;

    _charger();
  }

  Future<void> _charger() async {
    setState(() => _loading = true);

    final idToLoad =
        _doc?.id ?? widget.liste[_pos].id!;

    _doc = await _docService.getDocumentById(idToLoad);

    if (_doc?.globId != null) {
      _info =
          await _globService.getById(_doc!.globId!);
    } else {
      _info = null;
    }

    setState(() => _loading = false);
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";

    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _ouvrirChronique() async {
    final path =
        _doc?.chroniqueUrl?.trim() ?? "";

    if (path.isEmpty) return;

    final parts = path.split('/');

    if (parts.length != 2) return;

    await _storageService.openStorageFile(
      bucket: parts[0],
      fileName: parts[1],
    );
  }

  Future<void> _sauvegarderChronique() async {
    final path =
        _doc?.chroniqueUrl?.trim() ?? "";

    if (path.isEmpty) return;

    final parts = path.split('/');

    if (parts.length != 2) return;

    await _storageService.saveStorageFile(
      bucket: parts[0],
      fileName: parts[1],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final doc = _doc!;
    final info = _info;

    final bool ficheOfficielle =
        widget.critere == null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pop(context, true),
        ),

        title:
            const Text("Fiche document"),

        actions: [
          if (ficheOfficielle)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Modifier",
              onPressed: () async {
                final updated =
                    await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Dialog(
                    child: SizedBox(
                      width: 420,
                      child: DocumentForm(
                        doc: doc,
                        info: info,
                      ),
                    ),
                  ),
                );

                if (updated == true) {
                  await _charger();
                }
              },
            ),

          if (doc.chroniqueUrl != null &&
              doc.chroniqueUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
              ),
              tooltip: "Ouvrir",
              onPressed: _ouvrirChronique,
            ),

          if (doc.chroniqueUrl != null &&
              doc.chroniqueUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.save_alt,
              ),
              tooltip: "Sauvegarder",
              onPressed:
                  _sauvegarderChronique,
            ),

          if (ficheOfficielle)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Supprimer",
              onPressed: () async {
                final confirm =
                    await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title:
                        const Text("Supprimer"),
                    content: Text(
                      "Supprimer ${doc.titre} ?",
                    ),
                    actions: [
                      ElevatedButton(
                        child: const Text(
                            "Supprimer"),
                        onPressed: () =>
                            Navigator.pop(
                                context,
                                true),
                      ),
                      ElevatedButton(
                        child:
                            const Text("Annuler"),
                        onPressed: () =>
                            Navigator.pop(
                                context,
                                false),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await _docService
                      .deleteDocument(
                          doc.id!);

                  if (!mounted) return;

                  Navigator.pop(
                      context, true);
                }
              },
            ),
        ],
      ),

      body: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(
            maxWidth: 420,
          ),
          child: Padding(
            padding:
                const EdgeInsets.all(16),
            child: ListView(
              children: [
                _ligne(
                  "ID",
                  "${doc.id}",
                ),

                _ligne(
                  "Début",
                  _fmt(info?.debut),
                ),

                _ligne(
                  "Fin",
                  _fmt(info?.fin),
                ),

                _ligne(
                  "Type",
                  info?.type ?? "DOC",
                ),

                _ligne(
                  "Date saisie",
                  _fmt(
                    doc.dateSaisie,
                  ),
                ),

                _ligne(
                  "Titre",
                  doc.titre,
                ),

                _ligne(
                  "Mot clé 1",
                  doc.motCle1 ?? "",
                ),

                _ligne(
                  "Mot clé 2",
                  doc.motCle2 ?? "",
                ),

                _ligne(
                  "Mot clé 3",
                  doc.motCle3 ?? "",
                ),

                _ligne(
                  "Chronique",
                  doc.chroniqueUrl ?? "",
                ),

                Padding(
                  padding:
                      const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Remarques",
                          style: TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          doc.rem ?? "",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ligne(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}