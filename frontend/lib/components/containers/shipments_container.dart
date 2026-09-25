import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/dashboard_store.dart';
import '../pure/shipment_card.dart';
import '../pure/empty_state_widget.dart';

class ShipmentsContainer extends StatefulWidget {
  const ShipmentsContainer({super.key});

  @override
  State<ShipmentsContainer> createState() => _ShipmentsContainerState();
}

class _ShipmentsContainerState extends State<ShipmentsContainer> {
  String? _currentlyPayingId;

  Future<void> _handlePayment(String shipmentId) async {
    setState(() {
      _currentlyPayingId = shipmentId;
    });

    final store = context.read<DashboardStore>();
    final success = await store.payShipment(shipmentId);

    if (mounted) {
      setState(() {
        _currentlyPayingId = null;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.successMessage ?? 'Payment successful!'),
            backgroundColor: const Color(0xFF0A7D00),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(store.errorMessage ?? 'Payment failed. Check your wallet balance.'),
            backgroundColor: const Color(0xFFD92D20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DashboardStore>();
    final shipments = store.shipments;

    if (store.isLoading && shipments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (shipments.isEmpty) {
      return const EmptyStateWidget(
        message: 'No shipments found',
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shipments.length,
      itemBuilder: (context, index) {
        final shipment = shipments[index];
        return ShipmentCard(
          shipment: shipment,
          isPaying: _currentlyPayingId == shipment.id,
          onPayPressed: () => _handlePayment(shipment.id),
        );
      },
    );
  }
}
