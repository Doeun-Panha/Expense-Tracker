import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/app_theme.dart';
import '../models/category_data.dart';
import '../models/transaction_model.dart';

class CategoryPieChart extends StatelessWidget {
  final List<Transaction> transactions;

  const CategoryPieChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenseTransactions = transactions.where((tx) => tx.type == TransactionType.expense).toList();
    
    if (expenseTransactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart_outline, size: 48, color: AppTheme.textSecondary),
            SizedBox(height: 8),
            Text('No expenses yet', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    final Map<String, double> categoryTotals = {};
    for (var tx in expenseTransactions) {
      categoryTotals[tx.categoryId] = (categoryTotals[tx.categoryId] ?? 0) + tx.amount;
    }

    final totalExpense = categoryTotals.values.fold(0.0, (sum, amt) => sum + amt);

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: categoryTotals.entries.map((entry) {
          final category = CategoryData.getCategoryById(entry.key);
          final percentage = (entry.value / totalExpense) * 100;
          
          return PieChartSectionData(
            color: category.color,
            value: entry.value,
            title: '${category.name}\n${percentage.toStringAsFixed(0)}%',
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titlePositionPercentageOffset: 0.55,
          );
        }).toList(),
      ),
    );
  }
}

class ExpenseLineChart extends StatelessWidget {
  final List<Transaction> transactions;

  const ExpenseLineChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Simplified line chart for weekly trend
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(2.6, 2),
              const FlSpot(4.9, 5),
              const FlSpot(6.8, 3.1),
              const FlSpot(8, 4),
              const FlSpot(9.5, 3),
              const FlSpot(11, 7),
            ],
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withOpacity(0.1),
            ),
          ),
          LineChartBarData(
            spots: [
              const FlSpot(0, 1),
              const FlSpot(2, 3),
              const FlSpot(4, 2),
              const FlSpot(6, 4),
              const FlSpot(8, 3),
              const FlSpot(10, 5),
            ],
            isCurved: true,
            color: AppTheme.expense,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
