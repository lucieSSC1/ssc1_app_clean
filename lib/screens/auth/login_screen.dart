// ============================================================
// FICHIER : ssc1_app/lib/screens/auth/login_screen.dart
// Fenêtre Connexion SSC1
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  // ------------------------------------------------------------
  // Connexion
  // ------------------------------------------------------------
  Future<void> _connexion() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = "Veuillez remplir tous les champs.";
        _loading = false;
      });
      return;
    }

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Connexion réussie
      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return;
      }

      // Cas improbable : user null
      setState(() {
        _error = "Connexion impossible.";
      });
    } catch (e) {
      final message = e.toString();

      if (message.contains("Email not confirmed") ||
          message.contains("email not confirmed")) {
        setState(() {
          _error =
              "Votre adresse email n’est pas confirmée.\n"
              "Veuillez cliquer sur le lien reçu par courriel,\n"
              "puis revenir à SSC1 pour vous connecter.";
        });
      } else {
        setState(() {
          _error = "Email ou mot de passe invalide.";
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
      appBar: AppBar(title: const Text("Connexion")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Connexion à SSC1",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  if (_error != null)
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
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

                  const SizedBox(height: 20),

                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _connexion,
                          child: const Text("Connexion"),
                        ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text("Mot de passe oublié ?"),
                  ),

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
