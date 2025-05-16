import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:never_forgett/i18n/translations.g.dart';

import '../../../application/providers/reminder_providers.dart';
import '../../../domain/models/reminder.dart';

class ReportScreen extends ConsumerStatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  TimeFilter selectedFilter = TimeFilter.lastMonth;

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersStreamProvider);
    final textTheme = Theme.of(context).textTheme;
    final report = context.texts.app.report;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          report.title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: reminders.when(
        data: (reminderList) {
          if (reminderList.isEmpty) {
            return Center(
              child: Text(
                report.noPaymentDataAvailable,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            );
          }

          final filteredReminders = _filterReminders(reminderList);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeFilter(),
                SizedBox(height: 16),
                _buildPaymentTrendsCard(context, filteredReminders),
                SizedBox(height: 16),
                _buildHighestPaymentsCard(context, filteredReminders),
                SizedBox(height: 16),
                _buildCategoryDistributionCard(context, filteredReminders),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(
          child: Text(context.texts.app.error.generalError),
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    final report = context.texts.app.report;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip(TimeFilter.lastMonth, report.lastMonth),
          SizedBox(width: 8),
          _filterChip(TimeFilter.last3Months, report.last3Months),
          SizedBox(width: 8),
          _filterChip(TimeFilter.last6Months, report.last6Months),
        ],
      ),
    );
  }

  Widget _filterChip(TimeFilter filter, String label) {
    return FilterChip(
      selected: selectedFilter == filter,
      label: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      onSelected: (selected) {
        setState(() {
          selectedFilter = filter;
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  List<Reminder> _filterReminders(List<Reminder> reminders) {
    final now = DateTime.now();
    final filterDate = switch (selectedFilter) {
      TimeFilter.lastMonth => now.subtract(Duration(days: 30)),
      TimeFilter.last3Months => now.subtract(Duration(days: 90)),
      TimeFilter.last6Months => now.subtract(Duration(days: 180)),
    };

    return reminders
        .where((reminder) => reminder.dueDate.isAfter(filterDate))
        .toList();
  }

  Widget _buildPaymentTrendsCard(
      BuildContext context, List<Reminder> reminders) {
    final report = context.texts.app.report;
    final monthlyTotals = _calculateMonthlyTotals(reminders);

    final maxAmount = monthlyTotals.values.isEmpty
        ? 100.0
        : monthlyTotals.values.reduce(max) * 1.2;
    final minAmount = monthlyTotals.values.isEmpty
        ? 0.0
        : monthlyTotals.values.reduce(min) * 0.8;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.paymentTrends,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: minAmount,
                  maxY: maxAmount,
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              '\$${value.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyTotals.entries.map((e) {
                        return FlSpot(
                          monthlyTotals.keys.toList().indexOf(e.key).toDouble(),
                          e.value,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighestPaymentsCard(
      BuildContext context, List<Reminder> reminders) {
    final report = context.texts.app.report;
    final highestPayments = _getHighestPayments(reminders);

    final maxAmount = highestPayments.isEmpty
        ? 100.0
        : highestPayments.map((r) => r.amount).reduce(max) * 1.2;
    final minAmount = highestPayments.isEmpty
        ? 0.0
        : highestPayments.map((r) => r.amount).reduce(min) * 0.8;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.highestPayments,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bar_chart,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  minY: minAmount,
                  maxY: maxAmount,
                  barGroups: highestPayments.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.amount,
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                            bottom: Radius.circular(0),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '\$${value.toStringAsFixed(0)}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistributionCard(
      BuildContext context, List<Reminder> reminders) {
    final report = context.texts.app.report;
    final categoryTotals = _calculateCategoryTotals(reminders);
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

    final maxAmount = categoryTotals.values.isEmpty
        ? 100.0
        : categoryTotals.values.reduce(max) * 1.2;

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  report.categoryDistribution,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Icon(Icons.pie_chart, color: Theme.of(context).primaryColor),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryTotals.entries.map((e) {
                    final percentage = (e.value / total * 100);

                    return PieChartSectionData(
                      value: e.value,
                      title: '${percentage.toStringAsFixed(1)}%',
                      radius: 80,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.5 + (e.value / maxAmount * 0.5)),
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: categoryTotals.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(
                              alpha: 0.5 + (e.value / maxAmount * 0.5)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.key,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '\$${e.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Map<DateTime, double> _calculateMonthlyTotals(List<Reminder> reminders) {
    final monthlyTotals = <DateTime, double>{};
    final now = DateTime.now();

    var date = switch (selectedFilter) {
      TimeFilter.lastMonth => now.subtract(Duration(days: 30)),
      TimeFilter.last3Months => now.subtract(Duration(days: 90)),
      TimeFilter.last6Months => now.subtract(Duration(days: 180)),
    };

    while (date.isBefore(now)) {
      monthlyTotals[DateTime(date.year, date.month)] = 0;
      date = DateTime(date.year, date.month + 1);
    }

    for (var reminder in reminders) {
      final monthKey = DateTime(reminder.dueDate.year, reminder.dueDate.month);
      monthlyTotals[monthKey] =
          (monthlyTotals[monthKey] ?? 0) + reminder.amount;
    }

    return Map.fromEntries(
      monthlyTotals.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  List<Reminder> _getHighestPayments(List<Reminder> reminders) {
    final filteredList = List<Reminder>.from(reminders)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return filteredList.take(5).toList();
  }

  Map<String, double> _calculateCategoryTotals(List<Reminder> reminders) {
    final categoryTotals = <String, double>{};

    for (var reminder in reminders) {
      categoryTotals[reminder.category] =
          (categoryTotals[reminder.category] ?? 0) + reminder.amount;
    }

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries.take(5));
  }
}

enum TimeFilter {
  lastMonth,
  last3Months,
  last6Months,
}
