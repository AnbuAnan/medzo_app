import 'package:fl_chart/fl_chart.dart';

class Analytics {
  int todayPatientsDoneCount;
  int todayPatientsSkippedCount;
  DateTime? startDate;
  DateTime? endDate;
  String selectedFilter;
  final int? rangeTotalCount;
  final int? rangeInPersonCount;
  final List<Map<String, dynamic>> monthlyData;
  List<BarChartGroupData> barGroups;
  List<Map<String, dynamic>> filteredData;

  Analytics({
    required this.todayPatientsDoneCount,
    required this.todayPatientsSkippedCount,
    required this.startDate,
    required this.endDate,
    required this.rangeTotalCount,
    required this.rangeInPersonCount,
    required this.monthlyData,
    required this.barGroups,
    required this.filteredData,
    required this.selectedFilter,
  });

  Analytics copyWith({
    int? todayPatientsDoneCount,
    int? todayPatientsSkippedCount,
    DateTime? startDate,
    DateTime? endDate,
    int? rangeTotalCount,
    int? rangeInPersonCount,
    List<Map<String, dynamic>>? monthlyData,
    List<BarChartGroupData>? barGroups,
    List<Map<String, dynamic>>? filteredData,
    String? selectedFilter,
  }) {
    return Analytics(
      todayPatientsDoneCount:
          todayPatientsDoneCount ?? this.todayPatientsDoneCount,
      todayPatientsSkippedCount:
          todayPatientsSkippedCount ?? this.todayPatientsSkippedCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rangeTotalCount: rangeTotalCount ?? this.rangeTotalCount,
      rangeInPersonCount: rangeInPersonCount ?? this.rangeInPersonCount,
      monthlyData: monthlyData ?? this.monthlyData,
      barGroups: barGroups ?? this.barGroups,
      filteredData: filteredData ?? this.filteredData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
