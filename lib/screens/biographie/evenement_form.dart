// ============================================================
// FICHIER : lib/screens/biographie/evenement_form.dart
// FORMULAIRE SSC1 — Ajouter + Modifier (rouge + validations visuelles)
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../models/event_categ_model.dart';

import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../services/event_categ_service.dart';

class EvenementForm extends StatefulWidget {
  final EvenementModel? evt;
  final GlobalInfo? info;

  const EvenementForm({super.key, this.evt, this.info});

  @override
  State<EvenementForm> createState() => _EvenementFormState();
}

class _EvenementFormState extends State<EvenementForm> {
  final _evtService = EvenementService();
  final _globService = GlobalInfoService();
  final _catService = EventCategService();

  DateTime? _debut;
  DateTime? _fin;
  String? _type;
  int? _categorie;

  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _mc1Ctrl = TextEditingController();
  final _mc2Ctrl = TextEditingController();
  final _mc3Ctrl = TextEditingController();

  bool _loading = false;
  bool _showErrors = false;
  List<EventCateg> _categories = [];

  @override
  void initState() {
    super.initState();
    _chargerInitial();
  }

  Future<void> _chargerInitial() async {
    _categories = await _catService.getAll();

    if (widget.evt == null) {
      // Mode AJOUTER
      _debut = DateTime.now();
      _fin = null;
      _type = "EVE";
      _categorie = null;
    } else {
      // Mode MODIFIER
      final e = widget.evt!;
      _nomCtrl.text = e.nom;
      _descCtrl.text = e.description ?? "";
      _mc1Ctrl.text = e.motCle1 ?? "";
      _mc2Ctrl.text = e.motCle2 ?? "";
      _mc3Ctrl.text = e.motCle3 ?? "";
      _categorie = e.categorie;

      // Si info déjà fournie
      if (widget.info != null) {
        _debut = widget.info!.debut;
        _fin = widget.info!.fin;
        _type = widget.info!.type;
        setState(() {});
        return;
      }

      // Sinon recharger glob_info
      if (e.globId != null) {
        final info = await _globService.getById(e.globId!);
        if (info != null) {
          _debut = info.debut;
          _fin = info.fin;
          _type = info.type;
          setState(() {});
        }
      }
    }

    setState(() {});
  }

  // ------------------------------------------------------------
  // VALIDATION
  // ------------------------------------------------------------
  Map<String, String?> _validate() {
    final errors = <String, String?>{};

    if (_nomCtrl.text.trim().isEmpty) {
      errors['nom'] = "Nom obligatoire";
    }

    if (_categorie == null) {
      errors['categorie'] = "Catégorie obligatoire";
    }

    if (_mc1Ctrl.text.trim().isEmpty &&
        _mc2Ctrl.text.trim().isEmpty &&
        _mc3Ctrl.text.trim().isEmpty) {
      errors['motcle'] = "Au moins un mot-clé requis";
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
    final initial = isDebut ? _debut ?? now : _fin ?? now;

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

  // ------------------------------------------------------------
  // SAUVEGARDE — VERSION FINALE SSC1
  // ------------------------------------------------------------
  Future<void> _save() async {
    final errors = _validate();

    if (errors.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    setState(() => _loading = true);

    try {
      print("DEBUG-FORM: SAVE démarré");
      print(
        "DEBUG-FORM: evt.id = ${widget.evt?.id}, globId = ${widget.evt?.globId}",
      );
      print(
        "DEBUG-FORM: debut = $_debut, fin = $_fin, type = $_type, categorie = $_categorie",
      );

      // 1) Construire glob_info
      GlobalInfo glob = GlobalInfo(
        id: widget.evt?.globId,
        debut: _debut,
        fin: _fin,
        type: _type ?? "EVE",
      );

      print("DEBUG-FORM: avant create/update glob_info, glob.id = ${glob.id}");

      // 2) UPDATE glob_info (ou CREATE)
      if (glob.id == null) {
        glob = await _globService.create(glob);
        print("DEBUG-FORM: glob_info créé, id = ${glob.id}");
      } else {
        glob = await _globService.update(glob);
        print("DEBUG-FORM: glob_info mis à jour, id = ${glob.id}");
        print(
          "DEBUG-FORM: retour de _globService.update(glob) → id=${glob.id}, debut=${glob.debut}, fin=${glob.fin}, type=${glob.type}",
        );
      }

      // ⭐⭐ Recharger glob_info après update pour refléter ce que Supabase renvoie
      final freshGlob = await _globService.getById(glob.id!);
      _debut = freshGlob?.debut;
      _fin = freshGlob?.fin;
      _type = freshGlob?.type;
      print(
        "DEBUG-FORM: après getById(glob.id), debut=${_debut}, fin=${_fin}, type=${_type}",
      );

      // 3) Construire evenement
      EvenementModel evt = EvenementModel(
        id: widget.evt?.id,
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        motCle1: _mc1Ctrl.text.trim(),
        motCle2: _mc2Ctrl.text.trim(),
        motCle3: _mc3Ctrl.text.trim(),
        categorie: _categorie,
        globId: glob.id,
      );

      print(
        "DEBUG-FORM: avant create/update evenement, evt.id = ${evt.id}, globId = ${evt.globId}",
      );

      // 4) UPDATE evenement (ou CREATE)
      if (evt.id == null) {
        evt = await _evtService.createEvenement(evt);
        print("DEBUG-FORM: evenement créé, id = ${evt.id}");
      } else {
        evt = await _evtService.updateEvenement(evt);
        print("DEBUG-FORM: evenement mis à jour, id = ${evt.id}");
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      print("DEBUG-FORM: ERREUR SAVE brute = $e");

      String msg = "Erreur système lors de la sauvegarde";

      if (e is PostgrestException) {
        final code = e.code;
        final details = e.details;
        final message = e.message;

        print(
          "DEBUG-FORM: PostgrestException code=$code, details=$details, message=$message",
        );

        if (code == "PGRST116") {
          msg =
              "Erreur Supabase (PGRST116) : aucune ligne trouvée lors de la mise à jour.\n"
              "Vérifier que l'ID de l'événement et de glob_info existent encore.";
        } else {
          msg = "Erreur Supabase ($code) : $message\n$details";
        }
      }

      await _popup(msg);
    }

    setState(() => _loading = false);
  }

  Future<void> _popup(String msg) async {
    await showDialog(
      context: context,
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

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final errors = _showErrors ? _validate() : {};

    return SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              widget.evt == null ? "Ajouter" : "Modifier",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  // Début
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

                  // Fin + message rouge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          padding: const EdgeInsets.only(left: 100, top: 0),
                          child: Text(
                            errors['dates']!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Type
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: Text(_type ?? "EVE")),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Catégorie
                  DropdownButtonFormField<int>(
                    value: _categorie,
                    decoration: InputDecoration(
                      labelText: "Catégorie",
                      errorText: errors['categorie'],
                    ),
                    items: _categories.map((c) {
                      return DropdownMenuItem<int>(
                        value: c.id,
                        child: Text(c.nom),
                      );
                    }).toList(),
                    onChanged: (v) {
                      _categorie = v;
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Nom
                  TextField(
                    controller: _nomCtrl,
                    decoration: InputDecoration(
                      labelText: "Nom",
                      errorText: errors['nom'],
                    ),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Mot-clé 1 (rouge)
                  TextField(
                    controller: _mc1Ctrl,
                    decoration: InputDecoration(
                      labelText: "Mot clé 1",
                      errorText: errors['motcle'],
                    ),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Mot-clé 2
                  TextField(
                    controller: _mc2Ctrl,
                    decoration: const InputDecoration(labelText: "Mot clé 2"),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Mot-clé 3
                  TextField(
                    controller: _mc3Ctrl,
                    decoration: const InputDecoration(labelText: "Mot clé 3"),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Description
                  TextField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 4,
                  ),

                  const SizedBox(height: 20),

                  Row(
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
                ],
              ),
            ),
        ],
      ),
    );
  }
}
