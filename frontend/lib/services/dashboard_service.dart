import 'api_client.dart';
import '../models/wallet_model.dart';
import '../models/shipment_model.dart';
import '../models/growth_model.dart';

class DashboardService {
  final ApiClient _client;

  DashboardService({ApiClient? client}) : _client = client ?? ApiClient();

  Future<DashboardOverviewModel> getOverview() async {
    final response = await _client.get('/dashboard/overview');
    if (response is Map<String, dynamic>) {
      return DashboardOverviewModel.fromJson(response);
    }
    throw const FormatException('Invalid overview response format');
  }

  Future<GrowthChartModel> getGrowthChart({String period = 'Year'}) async {
    final response = await _client.get(
      '/dashboard/growth',
      queryParams: {'period': period},
    );
    if (response is Map<String, dynamic>) {
      return GrowthChartModel.fromJson(response);
    }
    throw const FormatException('Invalid growth chart response format');
  }

  Future<List<ShipmentModel>> getRecentShipments() async {
    final response = await _client.get('/dashboard/shipments');
    if (response is List) {
      return response
          .map((item) => ShipmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw const FormatException('Invalid shipments response format');
  }

  Future<WalletModel> fundWallet(double amount) async {
    final response = await _client.post(
      '/dashboard/wallet/fund',
      body: {'amount': amount},
    );
    if (response is Map<String, dynamic>) {
      return WalletModel.fromJson(response);
    }
    throw const FormatException('Invalid wallet fund response format');
  }

  Future<ShipmentModel> payShipment(String shipmentId) async {
    final response = await _client.post(
      '/dashboard/shipments/$shipmentId/pay',
    );
    if (response is Map<String, dynamic>) {
      final shipmentData = response['shipment'] as Map<String, dynamic>? ?? response;
      return ShipmentModel.fromJson(shipmentData);
    }
    throw const FormatException('Invalid payment response format');
  }
}
