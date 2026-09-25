class GrowthChartModel {
  final List<String> labels;
  final List<double> values;

  const GrowthChartModel({
    required this.labels,
    required this.values,
  });

  factory GrowthChartModel.fromJson(Map<String, dynamic> json) {
    final rawLabels = json['labels'] as List<dynamic>? ?? [];
    final rawValues = json['values'] as List<dynamic>? ?? [];

    return GrowthChartModel(
      labels: rawLabels.map((e) => e.toString()).toList(),
      values: rawValues.map((e) => (e as num).toDouble()).toList(),
    );
  }
}
