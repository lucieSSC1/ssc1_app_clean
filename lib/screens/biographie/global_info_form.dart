// ssc1_app/lib/screens/biographie/global_info_form.dart
//
// Écran : Formulaire de création / modification d’une GlobalInfo
// ------------------------------------------------------------------
// Champs :
// - type (String)
// - début (DateTime)
// - fin (DateTime)
//
// Ce fichier n’existait pas dans structure 2, mais il est essentiel
// dans SSC1 pour gérer proprement le module GlobalInfo.

import 'package:flutter/material.dart';
import '../../models/global_info_model.dart';
import '../../services/global_info_service.dart';

class GlobalInfoForm extends StatefulWidget {
  final GlobalInfo? info;

  const GlobalInfoForm({super.key, this.info});

  @override
  State<GlobalInfoForm> createState() => _GlobalInfoFormState();
}

class _GlobalInfoFormState extends State<GlobalInfoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _typeCtrl;
  DateTime? _debut;
  DateTime? _fin;

  final _service = GlobalInfoService();

  @override
  void initState() {
    super.initState();

    _typeCtrl = TextEditingController(text: widget.info?.type ?? "");
    _debut = widget.info?.debut;
    _fin = widget.info?.fin;
  }

  @override
  void dispose() {
    _typeCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // Sélecteur de date
  // ------------------------------------------------------------
  Future<void> _pickDate(bool isDebut) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: isDebut ? (_debut ?? now) : (_fin ?? now),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isDebut) {
          _debut = picked;
        } else {
          _fin = picked;
        }
      });
    }
  }

  // ------------------------------------------------------------
  // Sauvegarde
  // ------------------------------------------------------------
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final info = GlobalInfo(
      id: widget.info?.id,
      type: _typeCtrl.text,
      debut: _debut,
      fin: _fin,
    );

    try {
      if (widget.info == null) {
        await _service.create(info);
      } else {
        await _service.update(widget.info!.id!, info);
      }

      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.info != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Modifier GlobalInfo" : "Créer GlobalInfo"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: _typeCtrl,
                decoration: _input("Type"),
                validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
              ),

              const SizedBox(height: 20),

              _dateField(
                label: "Début",
                value: _debut,
                onTap: () => _pickDate(true),
              ),

              const SizedBox(height: 20),

              _dateField(
                label: "Fin",
                value: _fin,
                onTap: () => _pickDate(false),
              ),

              const SizedBox(height: 30),

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

  Widget _dateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    final text = value == null
        ? "Aucune date"
        : "${value.day.toString().padLeft(2, '0')}-"
          "${value.month.toString().padLeft(2, '0')}-"
          "${value.year}";

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: _input(label),
        child: Text(text),
      ),
    );
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );
}