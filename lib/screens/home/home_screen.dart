// lib/screens/home/home_screen.dart
//
// �cran principal de SSC1.
// Affiche les 6 modules sous forme d�onglets :
// 1. Biographie
// 2. �tudes et Emploi
// 3. Loisirs
// 4. Gestionnaire de projet
// 5. G�n�rateur de chronologie
// 6. Gestionnaire de documents

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

// Import des modules
import '../biographie/biographie_home.dart';
import '../etude/etudes_home.dart';
import '../loisir/loisirs_home.dart';
import '../projet/projets_home.dart';
import '../chronologie/chronologie_home.dart';
import '../document/documents_home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Accueil"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Biographie'),
              Tab(text: '�tudes et emploi'),
              Tab(text: 'Loisirs'),
              Tab(text: 'Gestionnaire de projet'),
              Tab(text: 'G�n�rateur de chronologie'),
              Tab(text: 'Gestionnaire de documents'),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            BiographieHome(),
            EtudesHome(),
            LoisirsHome(),
            ProjetsHome(),
            ChronologieHome(),
            DocumentsHome(), // ? TON MODULE DOCUMENTS
          ],
        ),
      ),
    );
  }
}
