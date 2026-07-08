/// Arguments passed to authentication routes (like /login or /register).
class AuthFlowArguments {
  /// Whether the authentication flow was triggered by a guarded action.
  /// If true, the auth screen should `context.pop(AuthResult.authenticated)` on success
  /// instead of navigating to the home route.
  final bool isGuarded;

  const AuthFlowArguments({this.isGuarded = false});
}
