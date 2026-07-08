import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_background.dart';
import 'package:project/features/auth/presentation/widgets/custom_text_field.dart';

import 'package:project/core/utils/auth_result.dart';
import 'package:project/core/utils/auth_flow_arguments.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_phone_field.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _phoneNumber = '';
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
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
                "Create",
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
                "Account",
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
                "Join us to unlock the ultimate cinematic experience.",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: GoogleFonts.manrope().fontFamily,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              CustomTextField(
                label: "FULL NAME",
                hintText: "John Doe",
                controller: _nameController,
                enabled: !isLoading,
              ),

              const SizedBox(height: 24),

              CustomTextField(
                label: "EMAIL ADDRESS",
                hintText: "name@example.com",
                controller: _emailController,
                enabled: !isLoading,
              ),

              const SizedBox(height: 24),

              AuthPhoneField(
                enabled: !isLoading,
                onChanged: (phone) {
                  _phoneNumber = phone.completeNumber;
                },
              ),

              const SizedBox(height: 14),

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

              const SizedBox(height: 24),

              CustomTextField(
                label: "CONFIRM PASSWORD",
                hintText: "••••••••",
                obscureText: _isConfirmPasswordObscured,
                controller: _confirmPasswordController,
                enabled: !isLoading,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                    });
                  },
                ),
              ),

              const SizedBox(height: 40),

              PrimaryButton(
                text: "Sign Up",
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        final name = _nameController.text.trim();
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        final confirm = _confirmPasswordController.text;

                        if (name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            _phoneNumber.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }
                        if (password != confirm) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match'),
                            ),
                          );
                          return;
                        }

                        context.read<AuthCubit>().register(
                          name,
                          email,
                          password,
                          _phoneNumber,
                        );
                      },
              ),

              const SizedBox(height: 35),

              Center(
                child: GestureDetector(
                  onTap: () {
                    final extra = GoRouterState.of(context).extra;
                    // Usually we use context.pop() because we came from LoginScreen.
                    // But if somehow they got here directly, we can push/replace.
                    // A pop works best if they navigated Login -> Register.
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.pushReplacement(AppRouter.loginRoute, extra: extra);
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: "Sign In",
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
