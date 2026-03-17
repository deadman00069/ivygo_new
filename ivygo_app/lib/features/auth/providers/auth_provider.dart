import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ivygo_app/services/auth_service.dart';
import 'package:ivygo_app/services/api_client.dart';

/// Represents the authentication state of the application.
sealed class AuthState {
  const AuthState();
}

/// Initial state — no login attempt yet.
class AuthIdle extends AuthState {
  const AuthIdle();
}

/// Login is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// The user is authenticated. [token] is the session token.
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.token});
  final String token;
}

/// An authentication error occurred.
class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthIdle();

  AuthService get _service => authService;

  /// Attempt login with the given credentials.
  ///
  /// State transitions: [AuthLoading] → [AuthAuthenticated] | [AuthError]
  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final response = await _service.login(email, password);
      state = AuthAuthenticated(token: response.token);
    } on ApiException catch (e) {
      state = AuthError(message: e.message);
    } catch (_) {
      state = const AuthError(message: 'An unexpected error occurred.');
    }
  }

  /// Log the user out and clear the stored token.
  Future<void> logout() async {
    await _service.logout();
    state = const AuthIdle();
  }

  /// Check if a valid token exists on app start (for persistence).
  Future<void> checkAuth() async {
    final token = await _service.getToken();
    if (token != null && token.isNotEmpty) {
      state = AuthAuthenticated(token: token);
    } else {
      state = const AuthIdle();
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// Global auth state provider.
///
/// Use [authProvider] everywhere in the app to read/mutate auth state.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
