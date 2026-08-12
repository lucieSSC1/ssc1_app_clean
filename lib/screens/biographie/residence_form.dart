import 'package:flutter/material.dart';

import '../../models/residence_model.dart';
import '../../models/global_info_model.dart';

import '../../services/residence_service.dart';
import '../../services/global_info_service.dart';

class ResidenceForm extends StatefulWidget {
  final Residence? residence;

  const ResidenceForm({super.key, this.residence});

  @override
  State<ResidenceForm> createState() => _ResidenceFormState();
}

class _ResidenceFormState extends State<ResidenceForm> {
  final _formKey = GlobalKey<FormState>();

  final _adresseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();
  final _commentaireCtrl = TextEditingController();
  final _loyerCtrl = TextEditingController();

  DateTime? _debut;
  DateTime? _fin;

  final _service = ResidenceService();
  final _globService = GlobalInfoService();

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final r = widget.residence;

    if (r != null) {
      _adresseCtrl.text = r.adresse;
      _villeCtrl.text = r.ville;
      _provinceCtrl.text = r.province;
      _paysCtrl.text = r.pays;
      _commentaireCtrl.text = r.commentaire ?? "";
      _loyerCtrl.text = r.loyer?.toString() ?? "";

      if (r.globId != null) {
        final info = await _globService.getById(r.globId!);
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_debut == null || _fin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les dates début et fin sont obligatoires"),
        ),
      );
      return;
    }

    // -------------------------
    // GlobalInfo
    // -------------------------
    GlobalInfo info;

    if (widget.residence?.globId == null) {
      info = GlobalInfo(id: null, debut: _debut, fin: _fin, type: "RESI");

      info = await _globService.create(info);
    } else {
      info = GlobalInfo(
        id: widget.residence!.globId!,
        debut: _debut,
        fin: _fin,
        type: "RESI",
      );

      await _globService.update(info);
    }

    // -------------------------
    // Residence
    // -------------------------
    final r = Residence(
      id: widget.residence?.id,
      globId: info.id,
      adresse: _adresseCtrl.text,
      ville: _villeCtrl.text,
      province: _provinceCtrl.text,
      pays: _paysCtrl.text,
      commentaire: _commentaireCtrl.text,
      loyer: double.tryParse(_loyerCtrl.text),
    );

    if (widget.residence == null) {
      await _service.create(r);
    } else {
      await _service.update(r);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.residence != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier résidence" : "Nouvelle résidence"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              _field("Adresse", _adresseCtrl),
              _field("Ville", _villeCtrl),
              _field("Province", _provinceCtrl),
              _field("Pays", _paysCtrl),

              const SizedBox(height: 20),

              _field("Commentaire", _commentaireCtrl, maxLines: 3),

              const SizedBox(height: 20),

              TextFormField(
                controller: _loyerCtrl,
                decoration: const InputDecoration(
                  labelText: "Loyer (\$)",
                  border: OutlineInputBorder(),
                ),
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

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
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
