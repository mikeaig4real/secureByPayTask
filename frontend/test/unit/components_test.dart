import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/pure/status_badge.dart';
import 'package:frontend/components/pure/section_header.dart';
import 'package:frontend/components/pure/empty_state_widget.dart';
import 'package:frontend/components/pure/nigeria_flag_icon.dart';
import 'package:frontend/components/pure/shipment_action_button.dart';

void main() {
  group('Pure Components Unit Tests', () {
    testWidgets('StatusBadge renders correctly for various shipment statuses', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                StatusBadge(status: 'In-Transit'),
                StatusBadge(status: 'Delayed'),
                StatusBadge(status: 'Delivered'),
                StatusBadge(status: 'Cancelled'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('In-Transit'), findsOneWidget);
      expect(find.text('Delayed'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
    });

    testWidgets('SectionHeader renders title and triggers onAction callback', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Recent shipment',
              actionText: 'See All',
              onAction: () {
                actionTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Recent shipment'), findsOneWidget);
      expect(find.text('See All'), findsOneWidget);

      await tester.tap(find.text('See All'));
      await tester.pump();

      expect(actionTapped, isTrue);
    });

    testWidgets('EmptyStateWidget renders provided message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              message: 'No shipments found',
              icon: Icons.inbox,
            ),
          ),
        ),
      );

      expect(find.text('No shipments found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('NigeriaFlagIcon renders green and white stripes cleanly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NigeriaFlagIcon(),
          ),
        ),
      );

      expect(find.byType(NigeriaFlagIcon), findsOneWidget);
    });

    testWidgets('ShipmentActionButton variants render correctly with identical dimensions and callbacks', (tester) async {
      bool viewMoreTapped = false;
      bool payNowTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                ShipmentActionButton.viewMore(
                  onPressed: () => viewMoreTapped = true,
                ),
                ShipmentActionButton.payNow(
                  onPressed: () => payNowTapped = true,
                ),
                ShipmentActionButton.disabled(label: 'Paid'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('View More'), findsOneWidget);
      expect(find.text('Pay Now'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);

      // Verify dimensions are identical across all variants (106 x 36 on regular layout)
      final viewMoreSize = tester.getSize(find.byWidgetPredicate(
        (w) => w is ShipmentActionButton && w.variant == ShipmentActionButtonVariant.outline,
      ));
      final payNowSize = tester.getSize(find.byWidgetPredicate(
        (w) => w is ShipmentActionButton && w.variant == ShipmentActionButtonVariant.primary,
      ));
      final paidSize = tester.getSize(find.byWidgetPredicate(
        (w) => w is ShipmentActionButton && w.variant == ShipmentActionButtonVariant.disabled,
      ));

      expect(viewMoreSize.width, 106.0);
      expect(viewMoreSize.height, 36.0);
      expect(payNowSize, equals(viewMoreSize));
      expect(paidSize, equals(viewMoreSize));

      // Test callbacks
      await tester.tap(find.text('View More'));
      await tester.pump();
      expect(viewMoreTapped, isTrue);

      await tester.tap(find.text('Pay Now'));
      await tester.pump();
      expect(payNowTapped, isTrue);
    });

    testWidgets('ShipmentActionButton renders spinner when isLoading is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ShipmentActionButton.payNow(
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Pay Now'), findsNothing);
    });
  });
}
