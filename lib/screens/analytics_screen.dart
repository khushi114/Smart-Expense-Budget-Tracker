/// AnalyticsScreen – Displays a Pie Chart and Bar Chart of expenses.

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../models/expense_model.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<Expense> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final expenses = await DatabaseHelper.instance.getAllExpenses();
    if (mounted) {
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    }
  }

  // ── Data Processing ─────────────────────────────────────────────────────────

  /// Category totals for the Pie Chart
  Map<String, double> get _categoryTotals {
    final Map<String, double> totals = {};
    for (final e in _expenses) {
      totals[e.category] = (totals[e.category] ?? 0.0) + e.amount;
    }
    return totals;
  }

  /// Daily totals (last 7 days) for the Bar Chart
  List<double> get _last7DaysTotals {
    final now = DateTime.now();
    final List<double> dailyTotals = List.filled(7, 0.0);
    
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      
      double total = 0;
      for (final e in _expenses) {
        if (e.date == dateString) {
          total += e.amount;
        }
      }
      dailyTotals[i] = total;
    }
    return dailyTotals;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final catTotals = _categoryTotals;
    final dailyTotals = _last7DaysTotals;
    final hasData = _expenses.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: !hasData
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: _buildPieChartSections(catTotals),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    'Last 7 Days',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final date = DateTime.now().subtract(Duration(days: 6 - value.toInt()));
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    DateFormat('E').format(date),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) return const SizedBox.shrink();
                                return Text(
                                  value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  textAlign: TextAlign.left,
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: _buildBarGroups(dailyTotals),
                        gridData: const FlGridData(show: true, drawVerticalLine: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  // ── Chart Builders ─────────────────────────────────────────────────────────

  List<PieChartSectionData> _buildPieChartSections(Map<String, double> catTotals) {
    return catTotals.entries.map((entry) {
      final colorHex = ExpenseCategory.colors[entry.key] ?? 0xFF78909C;
      return PieChartSectionData(
        color: Color(colorHex),
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _buildBarGroups(List<double> dailyTotals) {
    return List.generate(
      7,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: dailyTotals[i],
            color: const Color(0xFF1565C0),
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: dailyTotals.isEmpty ? 100 : dailyTotals.reduce((a, b) => a > b ? a : b) * 1.2,
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pie_chart_outline, size: 72, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Not enough data yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
