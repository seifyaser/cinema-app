/// Represents the typed result of an authentication flow.
enum AuthResult {
  /// The user successfully authenticated.
  authenticated,

  /// The user cancelled the authentication flow or closed the dialog.
  cancelled,
}
