import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../models/user_model.dart';
import 'sidebar_nav_item.dart';

class AppSidebar extends StatelessWidget {
  final UserModel? user;
  final String activeRoute;
  final ValueChanged<String>? onNavigate;
  final VoidCallback? onLogout;

  const AppSidebar({
    super.key,
    required this.user,
    this.activeRoute = '/dashboard',
    this.onNavigate,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE4E7EC)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SidebarNavItem(
                  icon: LucideIcons.layout_dashboard,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isActive: activeRoute == '/dashboard',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.ship,
                  title: 'Shipments',
                  route: '/shipments',
                  isActive: activeRoute == '/shipments',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.globe,
                  title: 'Our Services',
                  route: '/services',
                  isActive: activeRoute == '/services',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.bell,
                  title: 'Notifications',
                  route: '/notifications',
                  isActive: activeRoute == '/notifications',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.credit_card,
                  title: 'Wallet',
                  route: '/wallet',
                  isActive: activeRoute == '/wallet',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.locate_fixed,
                  title: 'My Addresses',
                  route: '/addresses',
                  isActive: activeRoute == '/addresses',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.badge_dollar_sign,
                  title: 'Invite & Earn',
                  route: '/invite',
                  isActive: activeRoute == '/invite',
                  onNavigate: onNavigate,
                ),
                const SizedBox(height: 4),
                SidebarNavItem(
                  icon: LucideIcons.hand_helping,
                  title: 'Help Center',
                  route: '/help',
                  isActive: activeRoute == '/help',
                  onNavigate: onNavigate,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    width: 38,
                    height: 38,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 38,
                      height: 38,
                      color: const Color(0xFF5A65AB),
                      child: Center(
                        child: Text(
                          (user?.firstName.isNotEmpty ?? false)
                              ? user!.firstName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null && user!.firstName.isNotEmpty
                            ? user!.firstName
                            : (user != null && user!.email.isNotEmpty ? user!.email.split('@').first : 'User'),
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF171717),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (user != null && user!.lastName.isNotEmpty)
                        Text(
                          user!.lastName,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF171717),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          InkWell(
            onTap: onLogout,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.log_out,
                    size: 18,
                    color: Color(0xFF667085),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
