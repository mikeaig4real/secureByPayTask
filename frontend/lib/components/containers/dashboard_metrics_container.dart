import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/responsive.dart';
import '../../stores/dashboard_store.dart';
import '../pure/stat_card.dart';
import '../pure/fund_wallet_dialog.dart';
import '../pure/section_header.dart';

class DashboardMetricsContainer extends StatelessWidget {
  const DashboardMetricsContainer({super.key});

  void _openFundWalletModal(BuildContext context) {
    final dashboardStore = context.read<DashboardStore>();
    showDialog(
      context: context,
      builder: (modalContext) => FundWalletDialog(
        onFund: (amount) async {
          final success = await dashboardStore.fundWallet(amount);
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  dashboardStore.successMessage ?? 'Wallet funded successfully',
                ),
                backgroundColor: const Color(0xFF0A7D00),
              ),
            );
          }
          return success;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DashboardStore>();
    final overview = store.overview;
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    if (store.isLoading && overview == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final rawBalance = overview?.wallet.balance ?? 0.0;
    final numberFormatter = NumberFormat('#,##0.00', 'en_US');
    final formattedBalance = 'N${numberFormatter.format(rawBalance)}';

    final totalShipments = (overview?.stats.totalShipments ?? 0).toString();
    final totalExports = (overview?.stats.totalExports ?? 0).toString();
    final totalImports = (overview?.stats.totalImports ?? 0).toString();

    final shipmentChange = (overview?.stats.shipmentChange ?? '').replaceAll('↑', '').replaceAll('↓', '').trim();
    final exportsChange = (overview?.stats.exportsChange ?? '').replaceAll('↑', '').replaceAll('↓', '').trim();
    final importsChange = (overview?.stats.importsChange ?? '').replaceAll('↑', '').replaceAll('↓', '').trim();
    final vsLastMonth = overview?.stats.previousMonthShipments ?? 0;

    final walletCard = StatCard(
      title: 'Your Balance',
      value: formattedBalance,
      icon: Icons.account_balance_wallet_rounded,
      isWallet: true,
      actionButtonText: 'Fund Wallet',
      onActionPressed: () => _openFundWalletModal(context),
    );

    final shipmentsCard = StatCard(
      title: 'Total Shipment',
      value: totalShipments,
      icon: Icons.local_shipping_outlined,
      iconColor: const Color(0xFFE08A00),
      iconBgColor: const Color(0xFFFFF5EA),
      changeText: shipmentChange.isNotEmpty ? shipmentChange : null,
      subtitle: 'Vs last month: $vsLastMonth',
    );

    final exportsCard = StatCard(
      title: 'Total Exports',
      value: totalExports,
      icon: Icons.north,
      iconColor: const Color(0xFF0A7D00),
      iconBgColor: const Color(0xFFEBFFE2),
      changeText: exportsChange.isNotEmpty ? exportsChange : null,
      subtitle: 'Vs last month: $vsLastMonth',
    );

    final importsCard = StatCard(
      title: 'Total Import',
      value: totalImports,
      icon: Icons.south,
      iconColor: const Color(0xFF049FA7),
      iconBgColor: const Color(0xFFD7FDFF),
      changeText: importsChange.isNotEmpty ? importsChange : null,
      subtitle: 'Vs last month: $vsLastMonth',
    );

    final cardsGrid = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              walletCard,
              const SizedBox(height: 12),
              shipmentsCard,
              const SizedBox(height: 12),
              exportsCard,
              const SizedBox(height: 12),
              importsCard,
            ],
          )
        : isTablet
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  walletCard,
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: shipmentsCard),
                      const SizedBox(width: 12),
                      Expanded(child: exportsCard),
                      const SizedBox(width: 12),
                      Expanded(child: importsCard),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: walletCard),
                  const SizedBox(width: 14),
                  Expanded(flex: 2, child: shipmentsCard),
                  const SizedBox(width: 14),
                  Expanded(flex: 2, child: exportsCard),
                  const SizedBox(width: 14),
                  Expanded(flex: 2, child: importsCard),
                ],
              );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Overview',
          fontSize: 22,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD0D5DD)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'This Month',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF344054),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Color(0xFF667085),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        cardsGrid,
      ],
    );
  }
}
