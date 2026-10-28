// ssc1_app/lib/screens/acquisition/acquisition_form.dart
// PARTIE1
// FORMULAIRE : Acquisition (version SSC1)
// ---------------------------------------
// - Ajouter / Modifier
// - Validations visuelles
// - glob_info (début / fin / type)
// - Champs AcquisitionModel
// - Sélection vendeur (Sélectionner + Gérer)
// - Coordonnées vendeur (Option C — carte encadrée)
// ---------------------------------------

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/acquisition_model.dart';
import '../../models/global_info_model.dart';
import '../../models/vendeur_model.dart';
import '../../models/maintenance_model.dart';

import '../../services/acquisition_service.dart';
import '../../services/global_info_service.dart';
import '../../services/vendeur_service.dart';
import '../../services/maintenance_service.dart';

import '../vendeur/vendeur_list.dart';
import '../maintenance/maintenance_list.dart';

class AcquisitionForm extends StatefulWidget {
  final AcquisitionModel? acq;
  final GlobalInfo? info;

  const AcquisitionForm({super.key, this.acq, this.info});

  @override
  State<AcquisitionForm> createState() => _AcquisitionFormState();
}

class _AcquisitionFormState extends State<AcquisitionForm> {
  final _acqService = AcquisitionService();
  final _globService = GlobalInfoService();
  final _vendService = VendeurService();
  final _maintService = MaintenanceService();

  DateTime? _debut;
  DateTime? _fin;
  String? _type;

  final _nomCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _garantieCtrl = TextEditingController();
  DateTime? _expire;
  final _prixCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _factureCtrl = TextEditingController();

  int? _vendeurId;
  String _vendeurNom = "N/A";
  int _nbMaintenances = 0;

  // Coordonnées vendeur
  String? _vAdresse;
  String? _vVille;
  String? _vProv;
  String? _vCodePostal;
  String? _vPays;
  String? _vTel;
  String? _vFax;
  String? _vCourriel;
  String? _vSite;

  bool _loading = false;
  bool _showErrors = false;

  @override
  void initState() {
    super.initState();
    _chargerInitial();
  }

  Future<void> _chargerInitial() async {
    if (widget.acq == null) {
      _debut = DateTime.now();
      _fin = null;
      _type = "ACQU";
      _expire = null;
    } else {
      final a = widget.acq!;
      _nomCtrl.text = a.nom;
      _descCtrl.text = a.description ?? "";
      _garantieCtrl.text = a.garantie ?? "";
      _expire = a.expire;
      _prixCtrl.text = a.prix?.toString() ?? "";
      _commentCtrl.text = a.commentaire ?? "";
      _imageCtrl.text = a.image ?? "";
      _factureCtrl.text = a.facture ?? "";

      _vendeurId = a.vendeurId;

      if (_vendeurId != null) {
        final v = await _vendService.getById(_vendeurId!);
        if (v != null) {
          _vendeurNom = v.nom;
          _chargerCoordonnees(v);
        }
      }

      if (widget.info != null) {
        _debut = widget.info!.debut;
        _fin = widget.info!.fin;
        _type = widget.info!.type;

        if (widget.acq?.id != null) {
          _nbMaintenances = await _maintService.countByAcquisition(
            widget.acq!.id!,
          );
        }

        setState(() {});

        return;
      }

      if (a.globId != null) {
        final info = await _globService.getById(a.globId!);
        if (info != null) {
          _debut = info.debut;
          _fin = info.fin;
          _type = info.type;
        }
      }
    }

    setState(() {});
  }

  void _chargerCoordonnees(Vendeur v) {
    _vAdresse = v.adresse;
    _vVille = v.ville;
    _vProv = v.prov;
    _vCodePostal = v.codePostal;
    _vPays = v.pays;
    _vTel = v.telephone;
    _vFax = v.fax;
    _vCourriel = v.courriel;
    _vSite = v.siteUrl;
  }

  // ------------------------------------------------------------
  // VALIDATIONS SSC1
  // ------------------------------------------------------------
  Map<String, String?> _validate() {
    final errors = <String, String?>{};

    if (_nomCtrl.text.trim().isEmpty) {
      errors['nom'] = "Nom obligatoire";
    }

    if (_debut == null) {
      errors['debut'] = "Début obligatoire";
    }

    if (_prixCtrl.text.trim().isEmpty) {
      errors['prix'] = "Prix obligatoire";
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

  Future<void> _pickExpire() async {
    final now = DateTime.now();
    final initial = _expire ?? now;

    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1),
      lastDate: DateTime(9999),
    );

    if (d != null) {
      setState(() => _expire = d);
    }
  }

  // ------------------------------------------------------------
  // SAUVEGARDE SSC1
  // ------------------------------------------------------------
  Future<void> _save() async {
    final errors = _validate();

    if (errors.isNotEmpty) {
      setState(() => _showErrors = true);
      return;
    }

    setState(() => _loading = true);

    try {
      GlobalInfo glob = GlobalInfo(
        id: widget.acq?.globId,
        debut: _debut,
        fin: _fin,
        type: _type ?? "ACQU",
      );

      if (glob.id == null) {
        glob = await _globService.create(glob);
      } else {
        glob = await _globService.update(glob);
      }

      final freshGlob = await _globService.getById(glob.id!);
      _debut = freshGlob?.debut;
      _fin = freshGlob?.fin;
      _type = freshGlob?.type;

      AcquisitionModel acq = AcquisitionModel(
        id: widget.acq?.id,
        nom: _nomCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        vendeurId: _vendeurId,
        garantie: _garantieCtrl.text.trim(),
        expire: _expire,
        prix: double.tryParse(_prixCtrl.text.trim()),
        commentaire: _commentCtrl.text.trim(),
        image: _imageCtrl.text.trim(),
        facture: _factureCtrl.text.trim(),
        globId: glob.id,
      );

      if (acq.id == null) {
        acq = await _acqService.createAcquisition(acq);
      } else {
        acq = await _acqService.updateAcquisition(acq);
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

  // ------------------------------------------------------------
  // UI SSC1 — identique à événement_form
  // ------------------------------------------------------------
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
              widget.acq == null ? "Ajouter" : "Modifier",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // CONTENU SCROLLABLE
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => _pickDate(true),
                      ),
                    ],
                  ),

                  if (errors['debut'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text(
                        errors['debut']!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  // Fin
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
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () => _pickDate(false),
                      ),
                    ],
                  ),

                  if (errors['dates'] != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Text(
                        errors['dates']!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
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
                      Expanded(child: Text(_type ?? "ACQU")),
                    ],
                  ),

                  const SizedBox(height: 10),

                 decoration: InputDecoration(
                      labelText: "Nom",
                      errorText: errors['nom'],
                    ),
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Prix
                  TextField(
                    controller: _prixCtrl,
                    decoration: InputDecoration(
                      labelText: "Prix",
                      errorText: errors['prix'],
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                  ),

                  // Description
                  TextField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 4,
                  ), // Nom
                  TextField(
                    controller: _nomCtrl,
                    

                  // ------------------------------------------------------------
                  // VENDEUR — Sélectionner + Gérer
                  // ------------------------------------------------------------
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Vendeur",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Bouton Sélectionner → mode sélection
                      IconButton(
                        icon: const Icon(Icons.playlist_add_check),
                        tooltip: "Sélectionner",
                        onPressed: () async {
                          final selected = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VendeurList(selectionMode: true),
                            ),
                          );

                          if (selected != null && selected is Vendeur) {
                            setState(() {
                              _vendeurId = selected.id;
                              _vendeurNom = selected.nom;
                              _chargerCoordonnees(selected);
                            });
                          }
                        },
                      ),

                      // Bouton Gérer → mode gestion
                      IconButton(
                        icon: const Icon(Icons.manage_accounts),
                        tooltip: "Gérer",
                        onPressed: () async {
                          final changed = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VendeurList(selectionMode: false),
                            ),
                          );

                          if (changed != null && _vendeurId != null) {
                            final v = await _vendService.getById(_vendeurId!);
                            if (v != null) {
                              setState(() {
                                _vendeurNom = v.nom;
                                _chargerCoordonnees(v);
                              });
                            }
                          }
                        },
                      ),

                      const Text(" : "),
                      const SizedBox(width: 2),

                      Expanded(
                        child: Text(
                          _vendeurNom,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------------------
                  // CARTE VENDEUR — Option C
                  // ------------------------------------------------------------
                  if (_vendeurId != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VENDEUR",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_vendeurNom),
                          if (_vAdresse != null && _vAdresse!.isNotEmpty)
                            Text(_vAdresse!),
                          Text(
                            [_vVille, _vProv, _vCodePostal, _vPays]
                                .where((e) => e != null && e!.isNotEmpty)
                                .join(", "),
                          ),
                          if (_vTel != null && _vTel!.isNotEmpty)
                            Text("Téléphone : $_vTel"),
                          if (_vFax != null && _vFax!.isNotEmpty)
                            Text("Fax : $_vFax"),
                          if (_vCourriel != null && _vCourriel!.isNotEmpty)
                            Text("Courriel : $_vCourriel"),
                          if (_vSite != null && _vSite!.isNotEmpty)
                            Text("Site Web : $_vSite"),
                        ],
                      ),
                    ),

                  // ------------------------------------------------------------
                  // MAINTENANCE
                  // ------------------------------------------------------------
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Maintenance",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: widget.acq?.id == null
                            ? null
                            : () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MaintenanceList(
                                      acquId: widget.acq!.id!,
                                    ),
                                  ),
                                );

                                _nbMaintenances = await _maintService
                                    .countByAcquisition(widget.acq!.id!);

                                setState(() {});
                              },
                        child: const Text("Ouvrir"),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          widget.acq?.id == null
                              ? "N/A"
                              : (_nbMaintenances == 0
                                    ? "N/A"
                                    : "$_nbMaintenances enregistrement(s)"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Garantie
                  TextField(
                    controller: _garantieCtrl,
                    decoration: const InputDecoration(labelText: "Garantie"),
                  ),

                  // Expire
                  Row(
                    children: [
                      const SizedBox(width: 100, child: Text("Expire")),
                      TextButton(
                        onPressed: _pickExpire,
                        child: Text(_fmt(_expire)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: _pickExpire,
                      ),
                    ],
                  ),

                  // Image
                  TextField(
                    controller: _imageCtrl,
                    decoration: const InputDecoration(labelText: "Image (URL)"),
                  ),

                  // Facture
                  TextField(
                    controller: _factureCtrl,
                    decoration: const InputDecoration(
                      labelText: "Facture (URL)",
                    ),
                  ),

                  // Commentaire
                  TextField(
                    controller: _commentCtrl,
                    decoration: const InputDecoration(labelText: "Commentaire"),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),
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
