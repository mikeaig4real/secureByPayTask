import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders empty state placeholders for dashboard list and table views.
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final EdgeInsetsGeometry padding;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 40, color: const Color(0xFFD0D5DD)),
              const SizedBox(height: 12),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: const Color(0xFF98A2B3),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
