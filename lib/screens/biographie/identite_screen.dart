// ssc1_app/lib/screens/biographie/identite_screen.dart
//
// Écran : Identité (module Biographie)
// ------------------------------------
// Cet écran permet d’afficher et modifier les informations d’identité :
// - Nom
// - Prénom
// - Date de naissance
// - Lieu de naissance
// - Nationalité
//
// Le contenu sera connecté plus tard au service :
// /lib/services/biographie_service.dart
//
// Ce fichier constitue la base du module Identité.

import 'package:flutter/material.dart';

class IdentiteScreen extends StatefulWidget {
  const IdentiteScreen({super.key});

  @override
  State<IdentiteScreen> createState() => _IdentiteScreenState();
}

class _IdentiteScreenState extends State<IdentiteScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _dateNaissanceController = TextEditingController();
  final TextEditingController _lieuNaissanceController = TextEditingController();
  final TextEditingController _nationaliteController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateNaissanceController.dispose();
    _lieuNaissanceController.dispose();
    _nationaliteController.dispose();
    super.dispose();
  }

  void _sauvegarder() {
    // Plus tard : appel à BiographieService().saveIdentite(...)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Identité sauvegardée (fonction à venir).")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Identité"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInput("Nom", _nomController),
            const SizedBox(height: 16),

            _buildInput("Prénom", _prenomController),
            const SizedBox(height: 16),

            _buildInput("Date de naissance", _dateNaissanceController),
            const SizedBox(height: 16),

            _buildInput("Lieu de naissance", _lieuNaissanceController),
            const SizedBox(height: 16),

            _buildInput("Nationalité", _nationaliteController),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _sauvegarder,
              child: const Text("Sauvegarder"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}