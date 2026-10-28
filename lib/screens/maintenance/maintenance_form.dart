// lib/screens/maintenance/maintenance_form.dart
// lib/screens/maintenance/maintenance_form.dart
//
// FORMULAIRE : Maintenance (version SSC1)
// ---------------------------------------
// - Ajouter / Modifier
// - Validation date obligatoire
// - Réparateur = champ texte
// - Sans table Réparateur
// - Largeur 420 px
// ---------------------------------------

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/maintenance_model.dart';
import '../../services/maintenance_service.dart';

class MaintenanceForm extends StatefulWidget {
  final int acquId;
  final MaintenanceModel? maintenance;

  const MaintenanceForm({super.key, required this.acquId, this.maintenance});

  @override
  State<MaintenanceForm> createState() => _MaintenanceFormState();
}

class _MaintenanceFormState extends State<MaintenanceForm> {
  final _service = MaintenanceService();

  DateTime? _date;

  final _aEffectuerCtrl = TextEditingController();
  final _reparateurCtrl = TextEditingController();
  final _effectueCtrl = TextEditingController();

  final _dureeCtrl = TextEditingController();
  final _piecesCtrl = TextEditingController();
  final _coutCtrl = TextEditingController();

  final _factureCtrl = TextEditingController();

  bool _loading = false;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();

    if (widget.maintenance == null) {
      _date = DateTime.now();
    } else {
      final m = widget.maintenance!;

      _date = m.date;

      _aEffectuerCtrl.text = m.aEffectuer ?? "";
      _reparateurCtrl.text = m.reparateur ?? "";
      _effectueCtrl.text = m.effectue ?? "";

      _dureeCtrl.text = m.duree?.toString() ?? "";
      _piecesCtrl.text = m.pieces?.toString() ?? "";
      _coutCtrl.text = m.cout?.toString() ?? "";

      _factureCtrl.text = m.facture ?? "";
    }
  }

  @override
  void dispose() {
    _aEffectuerCtrl.dispose();
    _reparateurCtrl.dispose();
    _effectueCtrl.dispose();

    _dureeCtrl.dispose();
    _piecesCtrl.dispose();
    _coutCtrl.dispose();

    _factureCtrl.dispose();

    super.dispose();
  }

  Map<String, String?> _validate() {
    final errors = <String, String?>{};

    if (_date == null) {
      errors['date'] = "Date obligatoire";
    }

    if (_aEffectuerCtrl.text.trim().isEmpty) {
      errors['aEffectuer'] = "À effectuer obligatoire";
    }

    if (_reparateurCtrl.text.trim().isEmpty) {
      errors['reparateur'] = "Réparateur obligatoire";
    }

    if (_coutCtrl.text.trim().isEmpty) {
      errors['cout'] = "Coût obligatoire";
    }

    return errors;
  }

  String _fmt(DateTime? d) {
    if (d == null) return "-";

    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    );

    if (d != null) {
      setState(() => _date = d);
    }
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

  Future<void> _save() async {
    final errors = _validate();

    if (errors.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    setState(() => _loading = true);

    try {
      MaintenanceModel maintenance = MaintenanceModel(
        id: widget.maintenance?.id,
        acquId: widget.acquId,
        date: _date!,

        aEffectuer: _aEffectuerCtrl.text.trim(),
        reparateur: _reparateurCtrl.text.trim(),
        effectue: _effectueCtrl.text.trim(),

        duree: double.tryParse(_dureeCtrl.text.trim()),
        pieces: double.tryParse(_piecesCtrl.text.trim()),
        cout: double.tryParse(_coutCtrl.text.trim()),

        facture: _factureCtrl.text.trim(),
      );

      if (maintenance.id == null) {
        await _service.create(maintenance);
      } else {
        await _service.update(maintenance);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      String msg = "Erreur système lors de la sauvegarde";

      if (e is PostgrestException) {
        msg = "Erreur Supabase (${e.code}) : ${e.message}\n${e.details}";
      }

      await _popup(msg);
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
          // HEADER
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: Text(
              widget.maintenance == null
                  ? "Ajouter maintenance"
                  : "Modifier maintenance",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // CONTENU
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
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: _pickDate,
                        child: Text(_fmt(_date)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _pickDate,
                      ),
                    ],
                  ),

                  if (errors['date'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text(
                        errors['date']!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  TextField(
                    controller: _aEffectuerCtrl,
                    decoration: InputDecoration(
                      labelText: "À effectuer",
                      errorText: errors['aEffectuer'],
                    ),
                    maxLines: 3,
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  TextField(
                    controller: _reparateurCtrl,
                    decoration: InputDecoration(
                      labelText: "Réparateur",
                      errorText: errors['reparateur'],
                    ),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  TextField(
                    controller: _effectueCtrl,
                    decoration: const InputDecoration(labelText: "Effectué"),
                    maxLines: 3,
                  ),

                  TextField(
                    controller: _dureeCtrl,
                    decoration: const InputDecoration(labelText: "Durée"),
                    keyboardType: TextInputType.number,
                  ),

                  TextField(
                    controller: _piecesCtrl,
                    decoration: const InputDecoration(labelText: "Pièces"),
                    keyboardType: TextInputType.number,
                  ),

                  TextField(
                    controller: _coutCtrl,
                    decoration: InputDecoration(
                      labelText: "Coût (\$)",
                      errorText: errors['cout'],
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  TextField(
                    controller: _factureCtrl,
                    decoration: const InputDecoration(
                      labelText: "Facture (URL)",
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOUTONS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _save,
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
