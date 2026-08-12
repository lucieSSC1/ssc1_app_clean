// ssc1_app/lib/screens/biographie/acquisition_form.dart

import 'package:flutter/material.dart';

import '../../models/acquisition_model.dart';
import '../../models/global_info_model.dart';
import '../../models/vendeur_model.dart';

import '../../services/acquisition_service.dart';
import '../../services/global_info_service.dart';
import '../../services/vendeur_service.dart';

class AcquisitionForm extends StatefulWidget {
  final Acquisition? acquisition;

  const AcquisitionForm({super.key, this.acquisition});

  @override
  State<AcquisitionForm> createState() => _AcquisitionFormState();
}

class _AcquisitionFormState extends State<AcquisitionForm> {
  final _formKey = GlobalKey<FormState>();

  final _nomCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _prixCtrl = TextEditingController();

  DateTime? _debut;
  DateTime? _fin;
  Vendeur? _vendeur;

  final _acqService = AcquisitionService();
  final _globService = GlobalInfoService();
  final _vendService = VendeurService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final a = widget.acquisition;

    if (a != null) {
      _nomCtrl.text = a.nom;
      _descriptionCtrl.text = a.description ?? "";
      _prixCtrl.text = a.prix?.toString() ?? "";

      if (a.vendeurId != null) {
        _vendeur = await _vendService.getById(a.vendeurId!);
      }

      if (a.globId != null) {
        final info = await _globService.getById(a.globId!);
        if (info != null) {
          _debut = info.debut;
          _fin = info.fin;
        }
      }
    } else {
      _debut = DateTime.now();
      _fin = DateTime.now();
    }

    setState(() {});
  }

  Future<void> _choisirVendeur() async {
    final liste = await _vendService.getAll();

    final v = await showDialog<Vendeur>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text("Choisir un vendeur"),
        children: liste
            .map(
              (r) => SimpleDialogOption(
                child: Text(r.nom),
                onPressed: () => Navigator.pop(context, r),
              ),
            )
            .toList(),
      ),
    );

    if (v != null) {
      setState(() => _vendeur = v);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_debut == null || _fin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les dates début et fin sont obligatoires")),
      );
      return;
    }

    GlobalInfo info;

    if (widget.acquisition?.globId == null) {
      info = GlobalInfo(
        id: null,
        debut: _debut,
        fin: _fin,
        type: "ACQU",
      );

      final created = await _globService.create(info);
      info = created;
    } else {
      info = GlobalInfo(
        id: widget.acquisition!.globId!,
        debut: _debut,
        fin: _fin,
        type: "ACQU",
      );

      await _globService.update(info.id!, info);
    }

    final acq = Acquisition(
      id: widget.acquisition?.id,
      nom: _nomCtrl.text,
      description: _descriptionCtrl.text,
      prix: double.tryParse(_prixCtrl.text),
      vendeurId: _vendeur?.id,
      globId: info.id,
    );

    if (widget.acquisition == null) {
      await _acqService.create(acq);
    } else {
      await _acqService.update(acq);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.acquisition != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier acquisition" : "Nouvelle acquisition"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _nomCtrl,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: "Description"),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _prixCtrl,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              _dateField("Début", _debut, () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _debut ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _debut = d);
              }),

              const SizedBox(height: 20),

              _dateField("Fin", _fin, () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _fin ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100),
                );
                if (d != null) setState(() => _fin = d);
              }),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      _vendeur?.nom ?? "Aucun vendeur sélectionné",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _choisirVendeur,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? "Enregistrer" : "Créer"),
              ),
            ],
          ),
        ),
      ),
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
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(text),
      ),
    );
  }
}