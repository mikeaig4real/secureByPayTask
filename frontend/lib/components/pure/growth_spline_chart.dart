import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../models/growth_model.dart';

class GrowthSplineChart extends StatelessWidget {
  final GrowthChartModel? chartData;
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;
  final bool isLoading;

  const GrowthSplineChart({
    super.key,
    required this.chartData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 460;
        final cardPadding = isNarrow
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 18)
            : const EdgeInsets.all(24);

        return Container(
          padding: cardPadding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE4E7EC)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Company Growth',
                      style: GoogleFonts.dmSans(
                        fontSize: isNarrow ? 14.5 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF171717),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPeriodSelector(isNarrow),
                ],
              ),
              SizedBox(height: isNarrow ? 20 : 28),

              SizedBox(
                height: 240,
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    : (chartData == null || chartData!.values.isEmpty)
                        ? Center(
                            child: Text(
                              'No growth data available',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          )
                        : LineChart(_buildChartData(isNarrow)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector(bool isNarrow) {
    final periods = ['Year', 'Month', 'Week'];

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE4E7EC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = selectedPeriod.toLowerCase() == period.toLowerCase();
          return GestureDetector(
            onTap: () => onPeriodChanged(period),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 10 : 16,
                vertical: isNarrow ? 5 : 6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                period,
                style: GoogleFonts.dmSans(
                  fontSize: isNarrow ? 11 : 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? const Color(0xFF171717) : const Color(0xFF667085),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  LineChartData _buildChartData(bool isNarrow) {
    final values = chartData!.values;
    final labels = chartData!.labels;

    final spots = <FlSpot>[];
    for (int i = 0; i < values.length; i++) {
      spots.add(FlSpot(i.toDouble(), values[i]));
    }

    final double maxY = values.isNotEmpty
        ? (values.reduce((a, b) => a > b ? a : b) * 1.25)
        : 1000.0;

    return LineChartData(
      minX: 0,
      maxX: (values.length - 1).toDouble().clamp(0, double.infinity),
      minY: 0,
      maxY: maxY > 0 ? maxY : 1000,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY > 0 ? (maxY / 5) : 200,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Color(0xFFF0F2F5),
          strokeWidth: 1,
          dashArray: [4, 4],
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: isNarrow ? 34 : 42,
            interval: maxY > 0 ? (maxY / 5) : 200,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: GoogleFonts.dmSans(
                  fontSize: isNarrow ? 10 : 11,
                  color: const Color(0xFF98A2B3),
                  fontWeight: FontWeight.w400,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < labels.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    labels[index],
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      color: const Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final label = (spot.x.toInt() < labels.length) ? labels[spot.x.toInt()] : '';
              return LineTooltipItem(
                '$label: ${spot.y.toStringAsFixed(0)}',
                GoogleFonts.dmSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: const Color(0xFF5A65AB),
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF5A65AB).withValues(alpha: 0.18),
                const Color(0xFF5A65AB).withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
