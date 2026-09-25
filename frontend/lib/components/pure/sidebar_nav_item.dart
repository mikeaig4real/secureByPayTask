import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigable sidebar drawer tile.
class SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final bool isActive;
  final ValueChanged<String>? onNavigate;

  const SidebarNavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
    required this.isActive,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF262A48) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : const Color(0xFF667085),
        ),
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? Colors.white : const Color(0xFF667085),
          ),
        ),
        onTap: () => onNavigate?.call(route),
      ),
    );
  }
}
