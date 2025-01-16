import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/reminder_providers.dart';
import '../../../domain/models/reminder.dart';

class ReportScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(remindersStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Reports',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: reminders.when(
        data: (reminderList) {
          if (reminderList.isEmpty) {
            return Center(
              child: Text(
                'No payment data available',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentTrendsCard(context, reminderList),
                SizedBox(height: 16),
                _buildHighestPaymentsCard(context, reminderList),
                SizedBox(height: 16),
                _buildCategoryDistributionCard(context, reminderList),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stack) => Center(
            child: Text(
          'Error: $error',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        )),
      ),
    );
  }

  Widget _buildPaymentTrendsCard(
      BuildContext context, List<Reminder> reminders) {
    final monthlyTotals = _calculateMonthlyTotals(reminders);

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
                  'Payment Trends',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= monthlyTotals.length) {
                            return Text('');
                          }
                          final date =
                              monthlyTotals.keys.elementAt(value.toInt());
                          return Text(
                            '${date.month}/${date.year}',
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyTotals.entries
                          .map((e) => FlSpot(
                              monthlyTotals.keys
                                  .toList()
                                  .indexOf(e.key)
                                  .toDouble(),
                              e.value))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
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
    final highestPayments = _getHighestPayments(reminders);

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
                  'Highest Payments',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(Icons.bar_chart, color: Theme.of(context).primaryColor),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: highestPayments.isEmpty
                      ? 100
                      : highestPayments.first.amount * 1.2,
                  barGroups: highestPayments
                      .asMap()
                      .entries
                      .map((e) => BarChartGroupData(
                            x: e.key,
                            barRods: [
                              BarChartRodData(
                                toY: e.value.amount,
                                color: Theme.of(context).primaryColor,
                                width: 20,
                              ),
                            ],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= highestPayments.length) {
                            return Text('');
                          }
                          return Text(
                            highestPayments[value.toInt()].title,
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
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
    final categoryTotals = _calculateCategoryTotals(reminders);
    final total = categoryTotals.values.fold(0.0, (a, b) => a + b);

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
                  'Category Distribution',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                    return PieChartSectionData(
                      value: e.value,
                      title: '${(e.value / total * 100).toStringAsFixed(1)}%',
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
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
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.key,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '\$${e.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
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

    for (var reminder in reminders) {
      final date = DateTime(reminder.dueDate.year, reminder.dueDate.month);
      monthlyTotals[date] = (monthlyTotals[date] ?? 0) + reminder.amount;
    }

    return Map.fromEntries(
        monthlyTotals.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  List<Reminder> _getHighestPayments(List<Reminder> reminders) {
    return List.from(reminders)
      ..sort((a, b) => b.amount.compareTo(a.amount))
      ..take(5);
  }

  Map<String, double> _calculateCategoryTotals(List<Reminder> reminders) {
    final categoryTotals = <String, double>{};

    for (var reminder in reminders) {
      categoryTotals[reminder.category] =
          (categoryTotals[reminder.category] ?? 0) + reminder.amount;
    }

    return categoryTotals;
  }
}
