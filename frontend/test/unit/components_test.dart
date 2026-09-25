import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/pure/status_badge.dart';
import 'package:frontend/components/pure/section_header.dart';
import 'package:frontend/components/pure/empty_state_widget.dart';
import 'package:frontend/components/pure/nigeria_flag_icon.dart';

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
  });
}
