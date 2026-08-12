import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client = Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      await client.auth.signUp(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }
}
