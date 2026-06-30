import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../widgets/auth_background.dart';
import '../widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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

          const CustomTextField(label: "FULL NAME", hintText: "John Doe"),

          const SizedBox(height: 24),

          const CustomTextField(
            label: "EMAIL ADDRESS",
            hintText: "name@example.com",
          ),

          const SizedBox(height: 24),

          const AuthPhoneField(),

          const SizedBox(height: 14),

          CustomTextField(
            label: "PASSWORD",
            hintText: "••••••••",
            obscureText: _isPasswordObscured,
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
            onPressed: () {
              context.go(AppRouter.homeRoute);
            },
          ),

          const SizedBox(height: 35),

          Center(
            child: GestureDetector(
              onTap: () {
                context.go(AppRouter.loginRoute);
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
  }
}
