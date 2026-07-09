import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/screens/MovieScreenDetails.dart';
import 'package:project/features/booking/data/models/checkout_data_model.dart';
import 'package:project/features/tickets/presentation/screens/tickets_screen.dart';
import 'package:project/features/tickets/presentation/cubit/ticket_cubit.dart';
import 'package:project/features/booking/presentation/screens/booking_screen.dart';
import 'package:project/features/booking/presentation/screens/checkout_screen.dart';
import 'package:project/features/booking/presentation/cubit/booking_cubit.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../shared/main_layout.dart';
import '../di/dependency_injection.dart' as di;

abstract class AppRouter {
  // Auth Screens (User will provide implementation)
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';

  // Navigation Screens
  static const String homeRoute = '/home';
  static const String discoverRoute = '/discover';
  static const String ticketsRoute = '/tickets';
  static const String profileRoute = '/profile';
  static const String movieDetailsRoute = '/movieDetails';
  static const String bookingRoute = '/booking';
  static const String checkoutRoute = '/checkout';

  static GoRouter router() {
    return GoRouter(
      initialLocation: homeRoute,
      routes: [
        // ================= AUTH =================
        GoRoute(
          path: loginRoute,
          builder: (context, state) => BlocProvider(
            create: (_) => di.sl<AuthCubit>(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: registerRoute,
          builder: (context, state) => BlocProvider(
            create: (_) => di.sl<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        ),
        GoRoute(
          path: movieDetailsRoute,
          builder: (context, state) =>
              MovieDetailsScreen(movie: state.extra as MovieEntity),
        ),
        GoRoute(
          path: bookingRoute,
          builder: (context, state) {
            final movie = state.extra as MovieEntity;
            return BlocProvider(
              create: (context) => di.sl<BookingCubit>(param1: movie.id)..fetchAvailableDates(),
              child: BookingScreen(movie: movie),
            );
          },
        ),
        GoRoute(
          path: checkoutRoute,
          builder: (context, state) => CheckoutScreen(bookingData: state.extra as CheckoutDataModel),
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
                  builder: (context, state) => BlocProvider(
                    create: (context) => di.sl<HomeCubit>()..fetchMovies(),
                    child: const HomeScreen(),
                  ),
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
                  builder: (context, state) => BlocProvider(
                    create: (context) => di.sl<TicketCubit>()..fetchMyTickets(),
                    child: const TicketsScreen(),
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

