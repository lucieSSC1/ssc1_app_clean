// ============================================================
// FICHIER : ssc1_app/lib/screens/auth/auth_hub_screen.dart
// Fenêtre unique : Connexion / Créer un compte / Mot de passe oublié
// Version avec DEBUGGING complet
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';

class AuthHubScreen extends StatefulWidget {
  const AuthHubScreen({super.key});

  @override
  State<AuthHubScreen> createState() => _AuthHubScreenState();
}

class _AuthHubScreenState extends State<AuthHubScreen> {
  final supabase = Supabase.instance.client;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  String _debug = ""; // DEBUG

  // Modes : "login", "register", "forgot"
  String _mode = "login";

  // Effacer message d’erreur et debug quand on change de mode
  void _setMode(String mode) {
    setState(() {
      _mode = mode;
      _error = null;
      _debug = "";
    });
  }

  // ------------------------------------------------------------
  // Connexion
  // ------------------------------------------------------------
  Future<void> _connexion() async {
    setState(() {
      _loading = true;
      _error = null;
      _debug = "DEBUG: Tentative de connexion...";
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      setState(() {
        _debug = "DEBUG: Connexion réussie. User ID = ${response.user?.id}";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _error = "Email ou mot de passe invalide.";
        _debug = "DEBUG: Erreur de connexion : $e";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // ------------------------------------------------------------
  // Créer un compte (version corrigée + DEBUG)
  // ------------------------------------------------------------
  Future<void> _creerCompte() async {
    setState(() {
      _loading = true;
      _error = null;
      _debug = "DEBUG: Tentative de création de compte...";
    });

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() {
        _error = "Veuillez remplir tous les champs.";
        _debug = "DEBUG: Champs vides.";
      });
      _loading = false;
      return;
    }

    if (password != confirm) {
      setState(() {
        _error = "Les mots de passe ne correspondent pas.";
        _debug = "DEBUG: Mot de passe ≠ confirmation.";
      });
      _loading = false;
      return;
    }

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      // Si Supabase renvoie user=null → email déjà utilisé
      if (response.user == null) {
        setState(() {
          _error = "Ce compte existe déjà.";
          _debug = "DEBUG: Supabase a renvoyé user=null → email déjà utilisé.";
        });
        _loading = false;
        return;
      }

      setState(() {
        _debug = "DEBUG: Compte créé. User ID = ${response.user!.id}";
      });

      final loginResponse = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      setState(() {
        _debug += "\nDEBUG: Connexion automatique réussie.";
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _error = "Impossible de créer le compte.";
        _debug = "DEBUG: Erreur Supabase lors de signUp : $e";
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // ------------------------------------------------------------
  // Mot de passe oublié (simple)
  // ------------------------------------------------------------
  void _motDePasseOublie() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Mot de passe oublié"),
        content: const Text(
          "La fonction de récupération de mot de passe sera ajoutée bientôt.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // Interface
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SSC1 - Système de Support Cognitif")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 500),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _mode == "login"
                        ? "Connexion"
                        : _mode == "register"
                        ? "Créer un compte"
                        : "Mot de passe oublié",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),

                  if (_debug.isNotEmpty)
                    Text(
                      _debug,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blueGrey,
                      ),
                    ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  const SizedBox(height: 10),

                  if (_mode != "forgot")
                    TextField(
                      controller: _passwordCtrl,
                      decoration: const InputDecoration(
                        labelText: "Mot de passe",
                      ),
                      obscureText: true,
                    ),

                  const SizedBox(height: 10),

                  if (_mode == "register")
                    TextField(
                      controller: _confirmCtrl,
                      decoration: const InputDecoration(labelText: "Confirmer"),
                      obscureText: true,
                    ),

                  const SizedBox(height: 20),

                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            if (_mode == "login") _connexion();
                            if (_mode == "register") _creerCompte();
                            if (_mode == "forgot") _motDePasseOublie();
                          },
                          child: Text(
                            _mode == "login"
                                ? "Connexion"
                                : _mode == "register"
                                ? "Créer un compte"
                                : "Envoyer",
                          ),
                        ),

                  const SizedBox(height: 10),

                  if (_mode == "login") ...[
                    TextButton(
                      onPressed: () => _setMode("register"),
                      child: const Text("Créer un compte"),
                    ),
                    TextButton(
                      onPressed: () => _setMode("forgot"),
                      child: const Text("Mot de passe oublié ?"),
                    ),
                  ],

                  if (_mode == "register" || _mode == "forgot")
                    TextButton(
                      onPressed: () => _setMode("login"),
                      child: const Text("Retour à la connexion"),
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
