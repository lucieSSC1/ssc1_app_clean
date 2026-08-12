// ============================================================
// FICHIER : lib/screens/biographie/evenement_form.dart
// Formulaire Événement — Version stable synchronisée
// ============================================================

import 'package:flutter/material.dart';

import '../../models/evenement_model.dart';
import '../../models/global_info_model.dart';
import '../../models/event_categ_model.dart';

import '../../services/evenement_service.dart';
import '../../services/global_info_service.dart';
import '../../services/event_categ_service.dart';

class EvenementForm extends StatefulWidget {
  final EvenementModel? evt;

  const EvenementForm({super.key, this.evt});

  @override
  State<EvenementForm> createState() => _EvenementFormState();
}

class _EvenementFormState extends State<EvenementForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _mc1Ctrl = TextEditingController();
  final _mc2Ctrl = TextEditingController();
  final _mc3Ctrl = TextEditingController();

  DateTime? _debut;
  DateTime? _fin;
  String _type = "EVE";

  int? _categorie;
  List<EventCateg> _categories = [];

  final _evtService = EvenementService();
  final _globService = GlobalInfoService();
  final _catService = EventCategService();

  bool _ready = false;

  void _debug(String msg, [dynamic data]) {
    print("DEBUG-FORM: $msg");
    if (data != null) print("DEBUG-FORM-DATA: $data");
  }

  @override
  void initState() {
    super.initState();
    _charger();
  }

  // ------------------------------------------------------------
  // CHARGEMENT SYNCHRONISÉ
  // ------------------------------------------------------------
  Future<void> _charger() async {
    _debug("Chargement formulaire…");

    _categories = await _catService.getAll();
    _debug("Catégories chargées", _categories);

    final e = widget.evt;

    if (e != null) {
      _debug("Modification événement id=${e.id}");

      _nomCtrl.text = e.nom;
      _descCtrl.text = e.description ?? "";
      _mc1Ctrl.text = e.motCle1 ?? "";
      _mc2Ctrl.text = e.motCle2 ?? "";
      _mc3Ctrl.text = e.motCle3 ?? "";
      _categorie = e.categorie;

      if (e.globId != null) {
        final info = await _globService.getById(e.globId!);
        if (info != null) {
          _debut = info.debut;
          _fin = info.fin;
          _type = info.type;
        }
      }
    } else {
      _debug("Création nouvel événement");
      _debut = DateTime.now();
      _fin = DateTime.now();
    }

    setState(() => _ready = true);
  }

  // ------------------------------------------------------------
  // SAUVEGARDE
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      _debug("Validation échouée");
      return;
    }

    if (_categorie == null) {
      _debug("Catégorie non sélectionnée");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Choisir une catégorie")));
      return;
    }

    _debug("Sauvegarde…");

    GlobalInfo info;

    if (widget.evt?.globId == null) {
      info = GlobalInfo(id: null, debut: _debut, fin: _fin, type: _type);
      info = await _globService.create(info);
    } else {
      info = GlobalInfo(
        id: widget.evt!.globId!,
        debut: _debut,
        fin: _fin,
        type: _type,
      );
      await _globService.update(info);
    }

    final evt = EvenementModel(
      id: widget.evt?.id,
      globId: info.id,
      nom: _nomCtrl.text,
      categorie: _categorie,
      motCle1: _mc1Ctrl.text,
      motCle2: _mc2Ctrl.text,
      motCle3: _mc3Ctrl.text,
      description: _descCtrl.text,
    );

    if (widget.evt == null) {
      await _evtService.createEvenement(evt);
    } else {
      await _evtService.updateEvenement(evt);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isEdit = widget.evt != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier événement" : "Nouvel événement"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _dateRow(),
                  const SizedBox(height: 12),
                  _dropdownCategorie(),
                  const SizedBox(height: 12),
                  _field("Nom", _nomCtrl),
                  const SizedBox(height: 12),
                  _field("Mot clé 1", _mc1Ctrl),
                  _field("Mot clé 2", _mc2Ctrl),
                  _field("Mot clé 3", _mc3Ctrl),
                  const SizedBox(height: 12),
                  _field("Description", _descCtrl, maxLines: 4),
                  const SizedBox(height: 20),
                  _buttons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // WIDGETS
  // ------------------------------------------------------------
  Widget _dropdownCategorie() {
    return DropdownButtonFormField<int>(
      value: _categorie,
      decoration: const InputDecoration(
        labelText: "Catégorie",
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: _categories
          .map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.nom)))
          .toList(),
      onChanged: (v) => setState(() => _categorie = v),
      validator: (v) => v == null ? "Choisir une catégorie" : null,
    );
  }

  Widget _dateRow() {
    return Row(
      children: [
        Expanded(
          child: _dateField("Début", _debut, () async {
            final d = await showDatePicker(
              context: context,
              initialDate: _debut ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
            );
            if (d != null) setState(() => _debut = d);
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dateField("Fin", _fin, () async {
            final d = await showDatePicker(
              context: context,
              initialDate: _fin ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
            );
            if (d != null) setState(() => _fin = d);
          }),
        ),
      ],
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
    );
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
    final text = value == null
        ? "Choisir"
        : "${value.day.toString().padLeft(2, '0')}-"
              "${value.month.toString().padLeft(2, '0')}-"
              "${value.year}";

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        child: Text("$label : $text"),
      ),
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: _save, child: const Text("OK")),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer"),
        ),
      ],
    );
  }
}
