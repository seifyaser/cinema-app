import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/utils/auth_flow_arguments.dart';
import 'package:project/core/utils/auth_result.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/social_icon_button.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          final extra = GoRouterState.of(context).extra;
          final isGuarded = extra is AuthFlowArguments ? extra.isGuarded : false;

          if (isGuarded) {
            context.pop(AuthResult.authenticated);
          } else {
            context.go(AppRouter.homeRoute);
          }
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AuthBackground(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),

        children: [
          const SizedBox(height: 15),

          Center(
            child: Text(
              "CINEMA",
              style: TextStyle(
                color: colorScheme.primary,
                fontFamily: GoogleFonts.sora().fontFamily,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),

          const SizedBox(height: 35),

          Text(
            "Your Journey",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontFamily: GoogleFonts.sora().fontFamily,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              height: 0.95,
            ),
          ),

          Text(
            "Begins",
            style: TextStyle(
              color: colorScheme.primary,
              fontFamily: GoogleFonts.sora().fontFamily,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              height: 0.95,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Sign in to access your curated cinema experience.",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 40),

          CustomTextField(
            label: "EMAIL ADDRESS",
            hintText: "name@example.com",
            controller: _emailController,
            enabled: !isLoading,
          ),

          const SizedBox(height: 24),

          CustomTextField(
            label: "PASSWORD",
            hintText: "••••••••",
            obscureText: _isPasswordObscured,
            controller: _passwordController,
            enabled: !isLoading,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),

          const SizedBox(height: 14),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: colorScheme.primary,
                fontFamily: GoogleFonts.manrope().fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 25),

          PrimaryButton(
            text: "Sign In",
            isLoading: isLoading,
            onPressed: isLoading
                ? null
                : () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    if (email.isNotEmpty && password.isNotEmpty) {
                      context.read<AuthCubit>().login(email, password);
                    }
                  },
          ),

          const SizedBox(height: 35),

          Row(
            children: [
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "OR CONTINUE WITH",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: colorScheme.outlineVariant)),
            ],
          ),

          const SizedBox(height: 35),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SocialIconButton(icon: Icons.g_mobiledata),
              const SizedBox(width: 25),
              const SocialIconButton(icon: Icons.apple),
            ],
          ),

          const SizedBox(height: 35),

          Center(
            child: GestureDetector(
              onTap: () {
                final extra = GoRouterState.of(context).extra;
                context.push(AppRouter.registerRoute, extra: extra);
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Create Account",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
      },
    );
  }
}
