import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../shared/main_layout.dart';

abstract class AppRouter {
  // Auth Screens (User will provide implementation)
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';

  // Navigation Screens
  static const String homeRoute = '/home';
  static const String discoverRoute = '/discover';
  static const String ticketsRoute = '/tickets';
  static const String profileRoute = '/profile';

  static GoRouter router() {
    return GoRouter(
      initialLocation: homeRoute,
      routes: [
        // ================= AUTH =================
        GoRoute(
          path: loginRoute,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: registerRoute,
          builder: (context, state) => const RegisterScreen(),
        ),

        // ================= MAIN LAYOUT (Stateful Bottom Nav) =================
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainLayout(navigationShell: navigationShell);
          },
          branches: [
            /// HOME
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: homeRoute,
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),

            /// search
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: discoverRoute,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('search Screen')),
                  ),
                ),
              ],
            ),

            /// tickets
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: ticketsRoute,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Tickets Screen')),
                  ),
                ),
              ],
            ),

            /// profile
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: profileRoute,
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Profile Screen')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
