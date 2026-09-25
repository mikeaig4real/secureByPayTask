import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders shipment status badges adhering to design color tokens.
class StatusBadge extends StatelessWidget {
  final String status;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.status,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.trim().toLowerCase()) {
      case 'in-transit':
      case 'transit':
        bg = const Color(0xFFFFF0DC);
        fg = const Color(0xFFC98810);
        break;
      case 'delayed':
        bg = const Color(0xFFD7FDFF);
        fg = const Color(0xFF049FA7);
        break;
      case 'cancelled':
      case 'canceled':
        bg = const Color(0xFFFFEBEB);
        fg = const Color(0xFFD92D20);
        break;
      case 'delivered':
      default:
        bg = const Color(0xFFEBFFE2);
        fg = const Color(0xFF0A7D00);
        break;
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: GoogleFonts.dmSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
