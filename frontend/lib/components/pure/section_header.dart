import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section header with optional trailing action button.
class SectionHeader extends StatelessWidget {
  final String title;
  final double fontSize;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.actionText,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget? actionWidget;

    if (trailing != null) {
      actionWidget = trailing;
    } else if (actionText != null && onAction != null) {
      actionWidget = InkWell(
        onTap: onAction,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Text(
            actionText!,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF344054),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF171717),
          ),
        ),
        if (actionWidget != null) actionWidget,
      ],
    );
  }
}
