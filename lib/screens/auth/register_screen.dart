// ============================================================
// FICHIER : ssc1_app/lib/screens/auth/register_screen.dart
// Fenêtre Créer un compte SSC1
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _success;

  // ------------------------------------------------------------
  // Créer un compte
  // ------------------------------------------------------------
  Future<void> _creerCompte() async {
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    // ---- Vérifications locales ----
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() {
        _error = "Veuillez remplir tous les champs.";
        _loading = false;
      });
      return;
    }

    if (password != confirm) {
      setState(() {
        _error = "Les mots de passe ne correspondent pas.";
        _loading = false;
      });
      return;
    }

    // ---- Appel Supabase à la dernière minute ----
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // ---- CAS : Email déjà utilisé ----
      if (response.user == null) {
        setState(() {
          _error = "Cette adresse email est déjà utilisée.";
          _loading = false;
        });
        return;
      }

      // ---- CAS : Succès ----
      setState(() {
        _success =
            "Votre compte a été créé.\n\n"
            "Supabase vous a envoyé un courriel de confirmation.\n"
            "Veuillez cliquer sur le lien dans ce courriel,\n"
            "puis revenir à SSC1 pour vous connecter.";
      });
    } catch (e) {
      final msg = e.toString();

      if (msg.contains("rate limit") || msg.contains("429")) {
        setState(() {
          _error =
              "Trop de tentatives de création de compte.\n"
              "Réessayez dans quelques minutes.";
        });
      } else if (msg.contains("invalid email")) {
        setState(() {
          _error = "Adresse email invalide.";
        });
      } else {
        setState(() {
          _error = "Impossible de créer le compte pour le moment.";
        });
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  // ------------------------------------------------------------
  // Interface
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 500),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Créer un compte SSC1",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),

                  if (_success != null)
                    Text(
                      _success!,
                      style: const TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _passwordCtrl,
                    decoration: const InputDecoration(
                      labelText: "Mot de passe",
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _confirmCtrl,
                    decoration: const InputDecoration(
                      labelText: "Confirmer le mot de passe",
                    ),
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _creerCompte,
                          child: const Text("Créer un compte"),
                        ),

                  const SizedBox(height: 10),

                  TextButton(
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
