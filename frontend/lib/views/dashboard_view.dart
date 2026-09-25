import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/responsive.dart';
import '../../stores/auth_store.dart';
import '../../stores/dashboard_store.dart';
import '../components/pure/app_sidebar.dart';
import '../components/pure/app_header.dart';
import '../components/pure/banner_card.dart';
import '../components/pure/placeholder_view.dart';
import '../components/pure/section_header.dart';
import '../components/containers/dashboard_metrics_container.dart';
import '../components/containers/growth_chart_container.dart';
import '../components/containers/shipments_container.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  String _activeRoute = '/dashboard';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardStore>().fetchDashboardData();
      final authStore = context.read<AuthStore>();
      if (authStore.user == null && !authStore.isLoading) {
        authStore.initialize();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleNavigate(String route) {
    if (_activeRoute == route) return;
    setState(() {
      _activeRoute = route;
    });
    if (!Responsive.isDesktop(context) && _scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleLogout() async {
    final authStore = context.read<AuthStore>();
    await authStore.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthStore>();
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    final sidebar = AppSidebar(
      user: authStore.user,
      activeRoute: _activeRoute,
      onLogout: _handleLogout,
      onNavigate: _handleNavigate,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFC),
      drawer: !isDesktop ? Drawer(child: sidebar) : null,
      body: Row(
        children: [
          if (isDesktop) sidebar,
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  user: authStore.user,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(child: _buildBody(isMobile)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(bool isMobile) {
    switch (_activeRoute) {
      case '/dashboard':
        return _buildDashboardBody(isMobile);
      case '/shipments':
        return _buildShipmentsPage(isMobile);
      case '/services':
        return PlaceholderView(
          title: 'Our Services',
          icon: LucideIcons.globe,
          description: 'Explore global freight forwarding, cargo shipping, customs handling, and secure escrow services.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      case '/notifications':
        return PlaceholderView(
          title: 'Notifications',
          icon: LucideIcons.bell,
          description: 'You have no unread notifications. Real-time cargo alerts, status milestones, and payment receipts will appear here.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      case '/wallet':
        return PlaceholderView(
          title: 'Wallet',
          icon: LucideIcons.credit_card,
          description: 'Manage linked accounts, escrow disbursements, transaction statements, and multi-currency balances.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      case '/addresses':
        return PlaceholderView(
          title: 'My Addresses',
          icon: LucideIcons.locate_fixed,
          description: 'Configure and save verified pickup hubs, delivery warehouses, and frequent business addresses.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      case '/invite':
        return PlaceholderView(
          title: 'Invite & Earn',
          icon: LucideIcons.badge_dollar_sign,
          description: 'Share your referral code with industry partners to earn transaction credits and reduced clearance rates.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      case '/help':
        return PlaceholderView(
          title: 'Help Center',
          icon: LucideIcons.hand_helping,
          description: 'Browse shipping guidelines, verify customs documentation requirements, or contact our 24/7 support specialists.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
      default:
        return PlaceholderView(
          title: 'Screen Coming Soon',
          icon: LucideIcons.layout_dashboard,
          description: 'This feature is currently under active development.',
          isMobile: isMobile,
          onReturn: () => _handleNavigate('/dashboard'),
        );
    }
  }

  Widget _buildDashboardBody(bool isMobile) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardStore>().fetchDashboardData(),
      color: const Color(0xFF5A65AB),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 32,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerCard(onAction: () => _handleNavigate('/shipments')),
            const SizedBox(height: 28),

            const DashboardMetricsContainer(),
            const SizedBox(height: 28),

            SectionHeader(
              title: 'Recent shipment',
              actionText: 'See All',
              onAction: () => _handleNavigate('/shipments'),
            ),
            const SizedBox(height: 16),

            const GrowthChartContainer(),
            const SizedBox(height: 20),

            const ShipmentsContainer(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentsPage(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipments',
                    style: GoogleFonts.dmSans(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF171717),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track, verify, and inspect all outgoing and incoming cargo.',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: const Color(0xFF667085),
                    ),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: () => _handleNavigate('/dashboard'),
                icon: const Icon(LucideIcons.layout_dashboard, size: 16),
                label: const Text('Dashboard'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF344054),
                  side: const BorderSide(color: Color(0xFFD0D5DD)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ShipmentsContainer(),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
