import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class ChartWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const ChartWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Group transactions by category and calculate total for expenses
    final Map<String, double> categoryTotals = {};
    double totalExpense = 0;

    for (var tx in transactions) {
      if (tx.type == 'expense') {
        categoryTotals.update(tx.category, (value) => value + tx.value, ifAbsent: () => tx.value);
        totalExpense += tx.value;
      }
    }

    if (categoryTotals.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Sem despesas para exibir no gráfico.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Map category totals to PieChartSectionData
    final List<PieChartSectionData> sections = categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalExpense) * 100;
      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Alimentação':
        return Colors.orange;
      case 'Transporte':
        return Colors.blue;
      case 'Moradia':
        return Colors.purple;
      case 'Educação':
        return Colors.indigo;
      case 'Lazer':
        return Colors.pink;
      case 'Saúde':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
