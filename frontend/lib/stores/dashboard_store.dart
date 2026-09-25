import 'package:flutter/foundation.dart';
import '../models/wallet_model.dart';
import '../models/shipment_model.dart';
import '../models/growth_model.dart';
import '../services/dashboard_service.dart';
import '../core/errors.dart';
import '../core/logger.dart';

class DashboardStore extends ChangeNotifier {
  final DashboardService _dashboardService;

  DashboardOverviewModel? _overview;
  GrowthChartModel? _growthChart;
  List<ShipmentModel> _shipments = [];
  String _selectedPeriod = 'Year';

  bool _isLoading = false;
  bool _isActionLoading = false;
  String? _errorMessage;
  String? _successMessage;

  DashboardStore({DashboardService? dashboardService})
      : _dashboardService = dashboardService ?? DashboardService();

  DashboardOverviewModel? get overview => _overview;
  GrowthChartModel? get growthChart => _growthChart;
  List<ShipmentModel> get shipments => List.unmodifiable(_shipments);
  String get selectedPeriod => _selectedPeriod;

  bool get isLoading => _isLoading;
  bool get isActionLoading => _isActionLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dashboardService.getOverview(),
        _dashboardService.getGrowthChart(period: _selectedPeriod),
        _dashboardService.getRecentShipments(),
      ]);

      _overview = results[0] as DashboardOverviewModel;
      _growthChart = results[1] as GrowthChartModel;
      _shipments = results[2] as List<ShipmentModel>;
    } on ApiException catch (e, st) {
      AppLogger.error('Dashboard API exception: ${e.message}', e, st);
      _errorMessage = e.message;
    } catch (e, st) {
      AppLogger.error('Failed to load dashboard data', e, st);
      _errorMessage = 'Failed to load dashboard data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectPeriod(String period) async {
    if (_selectedPeriod == period) return;
    _selectedPeriod = period;
    notifyListeners();

    try {
      _growthChart = await _dashboardService.getGrowthChart(period: period);
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    } catch (_) {
      _errorMessage = 'Failed to load chart for $period';
      notifyListeners();
    }
  }

  Future<bool> fundWallet(double amount) async {
    _isActionLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedWallet = await _dashboardService.fundWallet(amount);
      if (_overview != null) {
        _overview = DashboardOverviewModel(
          wallet: updatedWallet,
          stats: _overview!.stats,
        );
      }
      _successMessage = 'Successfully funded wallet with NGN ${amount.toStringAsFixed(2)}';
      _isActionLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isActionLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to fund wallet';
      _isActionLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> payShipment(String shipmentId) async {
    _isActionLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedShipment = await _dashboardService.payShipment(shipmentId);

      _shipments = _shipments.map((s) {
        if (s.id == shipmentId) {
          return updatedShipment;
        }
        return s;
      }).toList();

      final newOverview = await _dashboardService.getOverview();
      _overview = newOverview;

      _successMessage = 'Payment successful for shipment ${updatedShipment.trackingId}';
      _isActionLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _isActionLoading = false;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'Failed to process payment';
      _isActionLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
