import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  /// SIGN UP
  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user != null) {
      await supabase.from('profiles').insert({
        'id': user.id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
      });
    }
  }


  /// LOGIN
  Future<AuthResponse> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  /// RESET PASSWORD EMAIL
  Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  /// UPDATE PASSWORD
  Future<void> updatePassword(String password) async {
    await supabase.auth.updateUser(
      UserAttributes(password: password),
    );
  }

  /// CURRENT USER
  User? get currentUser => supabase.auth.currentUser;
}
