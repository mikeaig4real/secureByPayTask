import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/dashboard_store.dart';
import '../pure/growth_spline_chart.dart';

class GrowthChartContainer extends StatelessWidget {
  const GrowthChartContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<DashboardStore>();

    return GrowthSplineChart(
      chartData: store.growthChart,
      selectedPeriod: store.selectedPeriod,
      onPeriodChanged: (period) => store.selectPeriod(period),
      isLoading: store.isLoading && store.growthChart == null,
    );
  }
}
