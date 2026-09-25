import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders legal disclaimer links with managed TapGestureRecognizers.
class AuthLegalFooter extends StatefulWidget {
  final VoidCallback? onPrivacyPolicyTap;
  final VoidCallback? onTermsTap;

  const AuthLegalFooter({
    super.key,
    this.onPrivacyPolicyTap,
    this.onTermsTap,
  });

  @override
  State<AuthLegalFooter> createState() => _AuthLegalFooterState();
}

class _AuthLegalFooterState extends State<AuthLegalFooter> {
  late final TapGestureRecognizer _privacyPolicyRecognizer;
  late final TapGestureRecognizer _termsRecognizer;

  @override
  void initState() {
    super.initState();
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = widget.onPrivacyPolicyTap ?? () {};
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = widget.onTermsTap ?? () {};
  }

  @override
  void dispose() {
    _privacyPolicyRecognizer.dispose();
    _termsRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.dmSans(
          fontSize: 13,
          color: const Color(0xFF525252),
          height: 1.5,
        ),
        children: [
          const TextSpan(
            text: 'By clicking on create account you agree to our ',
          ),
          TextSpan(
            text: 'privacy policy',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5A65AB),
              decoration: TextDecoration.underline,
            ),
            recognizer: _privacyPolicyRecognizer,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'terms of use',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF5A65AB),
              decoration: TextDecoration.underline,
            ),
            recognizer: _termsRecognizer,
          ),
        ],
      ),
    );
  }
}
