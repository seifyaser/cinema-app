import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/di/dependency_injection.dart' as di;
import 'package:project/core/router/app_router.dart';
import 'package:project/core/storage/token_storage.dart';
import 'package:project/core/utils/auth_result.dart';
import 'package:project/core/utils/auth_flow_arguments.dart';
import 'package:project/core/widgets/auth_dialog.dart';

/// Centralized service to protect authenticated actions.
class AuthGuard {
  /// Executes the [action] if the user has a valid session.
  /// If not, prompts the user to log in and automatically executes the [action]
  /// upon a successful authentication.
  static Future<void> execute(BuildContext context, VoidCallback action) async {
    // 1. Check if token exists and is valid (not expired)
    final hasValidToken = await di.sl<TokenStorage>().hasValidToken();

    if (hasValidToken) {
      // User is already authenticated.
      action();
      return;
    }

    if (!context.mounted) return;

    // 2. Not authenticated -> Show the guest Auth Dialog
    final authResult = await showAuthDialog(context);

    // If the user cancelled the dialog, we just stop.
    if (authResult != AuthResult.authenticated) {
      return;
    }

    if (!context.mounted) return;

    // 3. User tapped "Sign In" -> Navigate to LoginScreen, passing AuthFlowArguments
    final loginResult = await context.push<AuthResult>(
      AppRouter.loginRoute,
      extra: const AuthFlowArguments(isGuarded: true),
    );

    // 4. If login was successful, seamlessly execute the original action.
    if (loginResult == AuthResult.authenticated) {
      action();
    }
  }
}
