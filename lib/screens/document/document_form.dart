// ============================================================
// FICHIER : lib/screens/document/document_form.dart
// FORMULAIRE SSC1 — Ajouter + Modifier Document
// ============================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/document_model.dart';
import '../../models/global_info_model.dart';

import '../../services/document_service.dart';
import '../../services/global_info_service.dart';
import '../../services/storage_service.dart';

class DocumentForm extends StatefulWidget {
  final DocumentModel? doc;
  final GlobalInfo? info;

  const DocumentForm({super.key, this.doc, this.info});

  @override
  State<DocumentForm> createState() => _DocumentFormState();
}

class _DocumentFormState extends State<DocumentForm> {
  final _docService = DocumentService();
  final _globService = GlobalInfoService();
  final _storageService = StorageService();

  DateTime? _debut;
  DateTime? _fin;
  String? _type;

  DateTime? _dateSaisie;

  final _titreCtrl = TextEditingController();
  final _mc1Ctrl = TextEditingController();
  final _mc2Ctrl = TextEditingController();
  final _mc3Ctrl = TextEditingController();
  final _remCtrl = TextEditingController();

  final _chroniqueCtrl = TextEditingController();

  File? _chroniqueFile;

  bool _loading = false;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _chargerInitial();
  }

  Future<void> _chargerInitial() async {
    if (widget.doc == null) {
      _debut = DateTime.now();
      _fin = null;
      _dateSaisie = DateTime.now();
      _type = "DOC";
    } else {
      final d = widget.doc!;

      _titreCtrl.text = d.titre;

      _mc1Ctrl.text = d.motCle1 ?? "";
      _mc2Ctrl.text = d.motCle2 ?? "";
      _mc3Ctrl.text = d.motCle3 ?? "";

      _remCtrl.text = d.rem ?? "";
      _chroniqueCtrl.text = d.chroniqueUrl ?? "";

      _dateSaisie = d.dateSaisie;

      if (widget.info != null) {
        _debut = widget.info!.debut;
        _fin = widget.info!.fin;
        _type = widget.info!.type;

        setState(() {});
        return;
      }

      if (d.globId != null) {
        final info = await _globService.getById(d.globId!);

        if (info != null) {
          _debut = info.debut;
          _fin = info.fin;
          _type = info.type;
        }
      }
    }

    setState(() {});
  }

  Map<String, String?> _validate() {
    final errors = <String, String?>{};

    if (_titreCtrl.text.trim().isEmpty) {
      errors['titre'] = "Titre obligatoire";
    }

    if (_mc1Ctrl.text.trim().isEmpty &&
        _mc2Ctrl.text.trim().isEmpty &&
        _mc3Ctrl.text.trim().isEmpty) {
      errors['motcle'] = "Au moins un mot-clé requis";
    }

    if (_chroniqueCtrl.text.trim().isEmpty) {
      errors['chronique'] = "Chronique obligatoire";
    }

    if (_debut != null && _fin != null && _fin!.isBefore(_debut!)) {
      errors['dates'] = "Fin doit être égale ou ultérieure à début";
    }

    return errors;
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";

    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _pickDate(bool isDebut) async {
    final now = DateTime.now();

    final initial = isDebut ? (_debut ?? now) : (_fin ?? now);

    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    );

    if (d != null) {
      setState(() {
        if (isDebut) {
          _debut = d;
        } else {
          _fin = d;
        }
      });
    }
  }

  Future<void> _pickDateSaisie() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _dateSaisie ?? DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    );

    if (d != null) {
      setState(() {
        _dateSaisie = d;
      });
    }
  }

  Future<void> _ouvrirChronique() async {
    final path = _chroniqueCtrl.text.trim();

    if (path.isEmpty) return;

    final parts = path.split('/');

    if (parts.length != 2) return;

    await _storageService.openStorageFile(bucket: parts[0], fileName: parts[1]);
  }

  Future<void> _sauvegarderChronique() async {
    final path = _chroniqueCtrl.text.trim();

    if (path.isEmpty) return;

    final parts = path.split('/');

    if (parts.length != 2) return;

    await _storageService.saveStorageFile(bucket: parts[0], fileName: parts[1]);
  }

  Future<void> _save() async {
    final errors = _validate();

    if (errors.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    setState(() => _loading = true);

    try {
      GlobalInfo glob = GlobalInfo(
        id: widget.doc?.globId,
        debut: _debut,
        fin: _fin,
        type: "DOC",
      );

      if (glob.id == null) {
        glob = await _globService.create(glob);
      } else {
        glob = await _globService.update(glob);
      }

      DocumentModel doc = DocumentModel(
        id: widget.doc?.id,
        globId: glob.id,
        dateSaisie: _dateSaisie,
        titre: _titreCtrl.text.trim(),
        motCle1: _mc1Ctrl.text.trim(),
        motCle2: _mc2Ctrl.text.trim(),
        motCle3: _mc3Ctrl.text.trim(),
        chroniqueUrl: _chroniqueCtrl.text.trim(),
        rem: _remCtrl.text.trim(),
      );

      if (doc.id == null) {
        doc = await _docService.createDocument(doc);
      } else {
        doc = await _docService.updateDocument(doc);
      }

      if (_chroniqueFile != null && doc.id != null) {
        final ext = _storageService.getExtension(_chroniqueFile!);

        final path = await _storageService.uploadFile(
          bucket: 'chronique',
          file: _chroniqueFile!,
          fileName: '${doc.id}.$ext',
        );

        if (path != null) {
          doc = doc.copyWith(chroniqueUrl: path);

          doc = await _docService.updateDocument(doc);

          _chroniqueCtrl.text = path;
        }
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      String msg = "Erreur système";

      if (e is PostgrestException) {
        msg = "Erreur Supabase (${e.code}) : ${e.message}";
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Info"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final errors = _showErrors ? _validate() : {};

    return SizedBox(
      width: 420,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              widget.doc == null ? "Ajouter" : "Modifier",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (_loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "ID",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(widget.doc?.id?.toString() ?? "Nouveau"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Début",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _pickDate(true),
                          child: Text(_fmt(_debut)),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Fin",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _pickDate(false),
                          child: Text(_fmt(_fin)),
                        ),
                      ],
                    ),

                    if (errors['dates'] != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Text(
                          errors['dates']!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(child: Text("DOC")),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Date saisie",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: _pickDateSaisie,
                          child: Text(_fmt(_dateSaisie)),
                        ),
                      ],
                    ),

                    TextField(
                      controller: _titreCtrl,
                      onChanged: (_) {
                        if (_showErrors) setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Titre",
                        errorText: errors['titre'],
                      ),
                    ),

                    TextField(
                      controller: _mc1Ctrl,
                      onChanged: (_) {
                        if (_showErrors) setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Mot clé 1",
                        errorText: errors['motcle'],
                      ),
                    ),

                    TextField(
                      controller: _mc2Ctrl,
                      onChanged: (_) {
                        if (_showErrors) setState(() {});
                      },
                      decoration: const InputDecoration(labelText: "Mot clé 2"),
                    ),

                    TextField(
                      controller: _mc3Ctrl,
                      onChanged: (_) {
                        if (_showErrors) setState(() {});
                      },
                      decoration: const InputDecoration(labelText: "Mot clé 3"),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: Text(
                            "Chronique",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        IconButton(
                          icon: const Icon(Icons.folder_open),
                          tooltip: "Sélectionner",
                          onPressed: () async {
                            final file = await _storageService.pickFile();

                            if (file != null) {
                              setState(() {
                                _chroniqueFile = file;
                                _chroniqueCtrl.text = file.path;
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    TextField(
                      controller: _chroniqueCtrl,
                      onChanged: (_) {
                        if (_showErrors) setState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: "Chronique",
                        errorText: errors['chronique'],
                      ),
                    ),

                    TextField(
                      controller: _remCtrl,
                      decoration: const InputDecoration(labelText: "Remarques"),
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("Enregistrer"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Annuler"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
