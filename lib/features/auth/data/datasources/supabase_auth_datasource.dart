import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthDatasource {
  final SupabaseClient _client;
  const SupabaseAuthDatasource(this._client);

  Future<User> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) throw const AuthException('Login failed');
    return response.user!;
  }

  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );
    if (response.user == null) throw const AuthException('Registration failed');
    return response.user!;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.aitherapist://login-callback',
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }
}
