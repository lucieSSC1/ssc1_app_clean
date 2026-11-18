// ============================================================
// FICHIER : lib/screens/chronologie/chronologie_form.dart
// SSC1 - Générateur de chronologie
// ============================================================

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../models/chronologie_item.dart';
import '../../pdf/chronologie_pdf.dart';
import '../../services/chronologie_service.dart';
import '../../utils/pdf_saver.dart';

class ChronologieForm extends StatefulWidget {
  const ChronologieForm({super.key});

  @override
  State<ChronologieForm> createState() => _ChronologieFormState();
}

class _ChronologieFormState extends State<ChronologieForm> {
  final _service = ChronologieService();

  DateTime? dateDebut;
  DateTime? dateFin;

  bool tous = false;

  bool res = false;
  bool acqu = false;
  bool ref = false;
  bool doc = false;
  bool eve = false;
  bool cour = false;
  bool empl = false;

  bool lois = false;
  bool proj = false;

  Future<void> _choisirDateDebut() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dateDebut ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        dateDebut = date;
      });
    }
  }

  Future<void> _choisirDateFin() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dateFin ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        dateFin = date;
      });
    }
  }

  String _fmt(DateTime? d) {
    if (d == null) return '';

    return '${d.day.toString().padLeft(2, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.year}';
  }

  void _message(String texte) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Information'),
        content: Text(texte),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _cocherTous(bool valeur) {
    setState(() {
      tous = valeur;

      res = valeur;
      acqu = valeur;
      ref = valeur;
      doc = valeur;
      eve = valeur;
      cour = valeur;
      empl = valeur;

      lois = valeur;
      proj = valeur;
    });
  }

  List<String> _typesSelectionnes() {
    final types = <String>[];

    if (res) types.add('RES');
    if (acqu) types.add('ACQU');
    if (ref) types.add('REF');
    if (doc) types.add('DOC');
    if (eve) types.add('EVE');
    if (cour) types.add('COUR');
    if (empl) types.add('EMPL');

    if (lois) types.add('LOIS');
    if (proj) types.add('PROJ');

    return types;
  }

  Future<void> _genererPdf() async {
    if (dateDebut == null) {
      _message('La date début est obligatoire.');
      return;
    }

    if (dateFin == null) {
      _message('La date fin est obligatoire.');
      return;
    }

    if (dateFin!.isBefore(dateDebut!)) {
      _message('La date fin doit être supérieure ou égale à la date début.');
      return;
    }

    final types = _typesSelectionnes();

    if (types.isEmpty) {
      _message('Veuillez sélectionner au moins un type.');
      return;
    }

    try {
      final List<ChronologieItem> items = await _service.genererChronologie(
        debut: dateDebut!,
        fin: dateFin!,
        types: types,
      );

      if (items.isEmpty) {
        _message('Aucune entrée.');
        return;
      }

      final bytes = await ChronologiePdf.generate(
        items: items,
        debut: dateDebut!,
        fin: dateFin!,
        types: types,
      );

      final path = await savePdf(bytes: bytes, baseName: 'ssc1_chronologie');

      if (!mounted) return;

      _message('PDF généré :\n$path');
    } catch (e) {
      _message('Erreur génération PDF.\n$e');
    }
  }

  Future<void> _ouvrirPdf() async {
    try {
      final ok = await openSavedPdf();

      if (!ok) {
        _message('Aucun PDF trouvé.');
      }
    } catch (e) {
      _message('Erreur ouverture PDF.');
    }
  }

  Future<void> _imprimerPdf() async {
    if (dateDebut == null) {
      _message('La date début est obligatoire.');
      return;
    }

    if (dateFin == null) {
      _message('La date fin est obligatoire.');
      return;
    }

    if (dateFin!.isBefore(dateDebut!)) {
      _message('La date fin doit être supérieure ou égale à la date début.');
      return;
    }

    final types = _typesSelectionnes();

    if (types.isEmpty) {
      _message('Veuillez sélectionner au moins un type.');
      return;
    }

    try {
      final items = await _service.genererChronologie(
        debut: dateDebut!,
        fin: dateFin!,
        types: types,
      );

      if (items.isEmpty) {
        _message('Aucune entrée.');
        return;
      }

      final bytes = await ChronologiePdf.generate(
        items: items,
        debut: dateDebut!,
        fin: dateFin!,
        types: types,
      );

      await Printing.layoutPdf(onLayout: (_) => bytes);
    } catch (e) {
      _message('Erreur impression PDF.');
    }
  }

  Widget _typeItem(bool valeur, String texte, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(value: valeur, onChanged: onChanged),
        Text(texte),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générateur de chronologie'),
        actions: [
          IconButton(
            tooltip: 'Générer PDF',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _genererPdf,
          ),
          IconButton(
            tooltip: 'Ouvrir PDF',
            icon: const Icon(Icons.open_in_new),
            onPressed: _ouvrirPdf,
          ),
          IconButton(
            tooltip: 'Imprimer PDF',
            icon: const Icon(Icons.print),
            onPressed: _imprimerPdf,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Date début : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 110, child: Text(_fmt(dateDebut))),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _choisirDateDebut,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Date fin : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 110, child: Text(_fmt(dateFin))),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _choisirDateFin,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _typeItem(tous, 'Tous', (v) => _cocherTous(v ?? false)),

            const SizedBox(height: 15),

            Row(
              children: [
                _typeItem(res, 'RES', (v) => setState(() => res = v ?? false)),
                const SizedBox(width: 20),

                _typeItem(
                  acqu,
                  'ACQU',
                  (v) => setState(() => acqu = v ?? false),
                ),
                const SizedBox(width: 20),

                _typeItem(ref, 'REF', (v) => setState(() => ref = v ?? false)),
              ],
            ),

            Row(
              children: [
                _typeItem(doc, 'DOC', (v) => setState(() => doc = v ?? false)),
                const SizedBox(width: 20),

                _typeItem(eve, 'EVE', (v) => setState(() => eve = v ?? false)),
                const SizedBox(width: 20),

                _typeItem(
                  cour,
                  'COUR',
                  (v) => setState(() => cour = v ?? false),
                ),
              ],
            ),

            Row(
              children: [
                _typeItem(
                  empl,
                  'EMPL',
                  (v) => setState(() => empl = v ?? false),
                ),
                const SizedBox(width: 20),

                _typeItem(
                  lois,
                  'LOIS',
                  (v) => setState(() => lois = v ?? false),
                ),
                const SizedBox(width: 20),

                _typeItem(
                  proj,
                  'PROJ',
                  (v) => setState(() => proj = v ?? false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
