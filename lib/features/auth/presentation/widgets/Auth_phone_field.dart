import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PHONE NUMBER",
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        IntlPhoneField(
          style: TextStyle(color: colorScheme.onSurface, fontFamily: GoogleFonts.manrope().fontFamily),
          dropdownTextStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontSize: 16,
          ),
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: Icon(
            Icons.arrow_drop_down,
            color: colorScheme.onSurfaceVariant,
          ),
          initialCountryCode: 'EG',
          decoration: InputDecoration(
            hintText: "123 456 7890",
            hintStyle: TextStyle(
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.08),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
