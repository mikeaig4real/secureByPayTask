class WalletModel {
  final double balance;
  final String currency;
  final String formatted;

  const WalletModel({
    required this.balance,
    required this.currency,
    required this.formatted,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final rawBalance = json['balance'];
    final double parsedBalance = (rawBalance is num) ? rawBalance.toDouble() : 0.0;
    final currency = json['currency'] as String? ?? 'NGN';
    final formatted = json['formatted'] as String? ?? '$currency ${parsedBalance.toStringAsFixed(2)}';

    return WalletModel(
      balance: parsedBalance,
      currency: currency,
      formatted: formatted,
    );
  }
}

class OverviewStatsModel {
  final int totalShipments;
  final int totalExports;
  final int totalImports;
  final double growthRate;
  final int previousMonthShipments;
  final String shipmentChange;
  final String exportsChange;
  final String importsChange;

  const OverviewStatsModel({
    required this.totalShipments,
    required this.totalExports,
    required this.totalImports,
    required this.growthRate,
    required this.previousMonthShipments,
    this.shipmentChange = '↑ 90%',
    this.exportsChange = '↑ 90%',
    this.importsChange = '↑ 90%',
  });

  factory OverviewStatsModel.fromJson(Map<String, dynamic> json) {
    int parseCount(dynamic value, int fallback) {
      if (value is Map<String, dynamic>) {
        final count = value['count'];
        return (count is num) ? count.toInt() : fallback;
      } else if (value is num) {
        return value.toInt();
      }
      return fallback;
    }

    String parseChange(dynamic value, String fallback) {
      if (value is Map<String, dynamic>) {
        final change = value['change'];
        return (change is String) ? change : fallback;
      }
      return fallback;
    }

    int parseVsLastMonth(dynamic value, int fallback) {
      if (value is Map<String, dynamic>) {
        final vs = value['vsLastMonth'];
        return (vs is num) ? vs.toInt() : fallback;
      }
      return fallback;
    }

    final shipmentRaw = json['totalShipment'] ?? json['totalShipments'];
    final exportsRaw = json['totalExports'] ?? json['totalExport'];
    final importsRaw = json['totalImport'] ?? json['totalImports'];

    final totalShipments = parseCount(shipmentRaw, 34);
    final totalExports = parseCount(exportsRaw, 34);
    final totalImports = parseCount(importsRaw, 34);

    final shipmentChange = parseChange(shipmentRaw, '↑ 90%');
    final exportsChange = parseChange(exportsRaw, '↑ 90%');
    final importsChange = parseChange(importsRaw, '↑ 90%');

    double parsedGrowthRate = 90.0;
    if (json['growthRate'] is num) {
      parsedGrowthRate = (json['growthRate'] as num).toDouble();
    } else {
      final changeStr = shipmentChange.replaceAll(RegExp(r'[^0-9.]'), '');
      if (changeStr.isNotEmpty) {
        parsedGrowthRate = double.tryParse(changeStr) ?? 90.0;
      }
    }

    final int prevMonth = (json['previousMonthShipments'] as num?)?.toInt() ??
        parseVsLastMonth(shipmentRaw, 4);

    return OverviewStatsModel(
      totalShipments: totalShipments,
      totalExports: totalExports,
      totalImports: totalImports,
      growthRate: parsedGrowthRate,
      previousMonthShipments: prevMonth,
      shipmentChange: shipmentChange,
      exportsChange: exportsChange,
      importsChange: importsChange,
    );
  }
}

class StatMetricItem {
  final String title;
  final int count;
  final String change;
  final int vsLastMonth;
  final String type;

  const StatMetricItem({
    required this.title,
    required this.count,
    required this.change,
    required this.vsLastMonth,
    required this.type,
  });

  factory StatMetricItem.fromJson(
    dynamic json, {
    String defaultTitle = '',
    int defaultCount = 34,
    String defaultChange = '↑ 90%',
  }) {
    if (json is Map<String, dynamic>) {
      final rawCount = json['count'];
      final count = (rawCount is num) ? rawCount.toInt() : defaultCount;
      final rawVs = json['vsLastMonth'];
      final vsLastMonth = (rawVs is num) ? rawVs.toInt() : 4;

      return StatMetricItem(
        title: json['title'] as String? ?? defaultTitle,
        count: count,
        change: json['change'] as String? ?? defaultChange,
        vsLastMonth: vsLastMonth,
        type: json['type'] as String? ?? 'positive',
      );
    } else if (json is num) {
      return StatMetricItem(
        title: defaultTitle,
        count: json.toInt(),
        change: defaultChange,
        vsLastMonth: 4,
        type: 'positive',
      );
    }
    return StatMetricItem(
      title: defaultTitle,
      count: defaultCount,
      change: defaultChange,
      vsLastMonth: 4,
      type: 'positive',
    );
  }
}

class DashboardOverviewModel {
  final WalletModel wallet;
  final OverviewStatsModel stats;

  const DashboardOverviewModel({
    required this.wallet,
    required this.stats,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) {
    final source = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return DashboardOverviewModel(
      wallet: WalletModel.fromJson(source['wallet'] as Map<String, dynamic>? ?? {}),
      stats: OverviewStatsModel.fromJson(source['stats'] as Map<String, dynamic>? ?? {}),
    );
  }
}
