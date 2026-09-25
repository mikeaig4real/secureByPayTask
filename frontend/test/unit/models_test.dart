import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/wallet_model.dart';
import 'package:frontend/models/shipment_model.dart';
import 'package:frontend/models/growth_model.dart';

void main() {
  group('UserModel Serialization', () {
    test('parses json with all fields', () {
      final json = {
        'id': 'u1',
        'firstName': 'Bunmi',
        'lastName': 'Tanny',
        'email': 'bunmi@securebypay.com',
        'phone': '+2348000000000',
      };
      final user = UserModel.fromJson(json);

      expect(user.id, 'u1');
      expect(user.firstName, 'Bunmi');
      expect(user.lastName, 'Tanny');
      expect(user.fullName, 'Bunmi Tanny');
      expect(user.email, 'bunmi@securebypay.com');
      expect(user.phone, '+2348000000000');
    });

    test('falls back gracefully on missing fields', () {
      final user = UserModel.fromJson({});
      expect(user.id, '');
      expect(user.firstName, '');
      expect(user.fullName, '');
    });
  });

  group('Wallet & Overview Models', () {
    test('parses wallet model correctly', () {
      final json = {
        'balance': 1500000.0,
        'currency': 'NGN',
        'formatted': 'NGN 1,500,000.00',
      };
      final wallet = WalletModel.fromJson(json);

      expect(wallet.balance, 1500000.0);
      expect(wallet.currency, 'NGN');
      expect(wallet.formatted, 'NGN 1,500,000.00');
    });

    test('parses overview stats with defaults', () {
      final stats = OverviewStatsModel.fromJson({
        'totalShipments': 42,
        'growthRate': 85.5,
      });

      expect(stats.totalShipments, 42);
      expect(stats.growthRate, 85.5);
      expect(stats.totalExports, 34);
    });

    test('parses real backend nested overview stats object with badge changes', () {
      final backendJson = {
        'totalShipment': {
          'title': 'Total Shipment',
          'count': 34,
          'change': '↑ 90%',
          'vsLastMonth': 4,
          'type': 'positive',
        },
        'totalExports': {
          'title': 'Total Exports',
          'count': 34,
          'change': '↑ 90%',
          'vsLastMonth': 4,
          'type': 'positive',
        },
        'totalImport': {
          'title': 'Total Import',
          'count': 34,
          'change': '↑ 90%',
          'vsLastMonth': 4,
          'type': 'positive',
        },
      };

      final stats = OverviewStatsModel.fromJson(backendJson);

      expect(stats.totalShipments, 34);
      expect(stats.totalExports, 34);
      expect(stats.totalImports, 34);
      expect(stats.shipmentChange, '↑ 90%');
      expect(stats.exportsChange, '↑ 90%');
      expect(stats.importsChange, '↑ 90%');
      expect(stats.growthRate, 90.0);
    });
  });

  group('ShipmentModel', () {
    test('parses shipment and supports copyWith', () {
      final json = {
        '_id': 's1',
        'trackingId': 'TRK-NG-001',
        'sender': 'Dangote Sugar',
        'receiver': 'Kano Distribution',
        'pickUp': 'Apapa Port, Lagos',
        'deliveryTo': 'Bompai, Kano',
        'amount': 250000.0,
        'currency': 'NGN',
        'status': 'In-Transit',
        'processingTime': '12 hours',
        'isPaid': false,
      };

      final shipment = ShipmentModel.fromJson(json);
      expect(shipment.id, 's1');
      expect(shipment.isPaid, false);

      final paidShipment = shipment.copyWith(isPaid: true);
      expect(paidShipment.isPaid, true);
      expect(paidShipment.trackingId, 'TRK-NG-001');
    });
  });

  group('GrowthChartModel', () {
    test('parses labels and values from dynamic lists', () {
      final json = {
        'labels': ['Jan', 'Feb', 'Mar'],
        'values': [10.5, 20.0, 35.8],
      };
      final chart = GrowthChartModel.fromJson(json);

      expect(chart.labels.length, 3);
      expect(chart.values.length, 3);
      expect(chart.labels.first, 'Jan');
      expect(chart.values.last, 35.8);
    });
  });
}
