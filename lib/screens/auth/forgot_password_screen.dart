// ============================================================
// FICHIER : ssc1_app/lib/screens/auth/forgot_password_screen.dart
// Fenêtre Mot de passe oublié (version simple)
// ============================================================

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mot de passe oublié"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
            maxHeight: 300,
          ),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Mot de passe oublié",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "La récupération de mot de passe sera ajoutée "
                    "dans une version future de SSC1.\n\n"
                    "Pour l’instant, veuillez contacter l’administrateur "
                    "si vous avez perdu votre mot de passe.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Retour"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
