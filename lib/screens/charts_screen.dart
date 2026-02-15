import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    // Process data for charts
    final expenseTransactions = transactions.where((t) => t.type == 'expense' && !t.deleted).toList();
    final incomeTransactions = transactions.where((t) => t.type == 'income' && !t.deleted).toList();
    
    // Group by category for Pie Chart
    final Map<String, double> categoryTotals = {};
    for (var tx in expenseTransactions) {
      categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.value;
    }

    final List<PieChartSectionData> pieSections = categoryTotals.entries.map((entry) {
        // Simple distinct color generation logic or map
        final isLarge = entry.value > (transactionProvider.totalExpense * 0.2);
        return PieChartSectionData(
          color: _getCategoryColor(entry.key),
          value: entry.value,
          title: '${((entry.value / transactionProvider.totalExpense) * 100).toStringAsFixed(1)}%',
          radius: isLarge ? 60 : 50,
          titleStyle: TextStyle(
            fontSize: isLarge ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Gráficos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pie Chart Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Despesas por Categoria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: pieSections.isEmpty 
                        ? const Center(child: Text("Sem dados de despesas"))
                        : PieChart(
                          PieChartData(
                            sections: pieSections,
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
                    ),
                    const SizedBox(height: 24),
                    // Legend
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categoryTotals.keys.map((cat) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 12, height: 12, color: _getCategoryColor(cat)),
                            const SizedBox(width: 4),
                            Text(cat.toUpperCase(), style: const TextStyle(fontSize: 12)),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
             const SizedBox(height: 16),
             // Placeholder for Bar Chart
             const Card(
               child: Padding(
                 padding: EdgeInsets.all(16.0),
                 child: SizedBox(
                   height: 200, 
                   child: Center(child: Text("Gráfico de Barras (Em breve)")),
                 ),
               ),
             )
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Basic mapping, could be moved to AppTheme or Utils
    switch (category) {
      case 'alimentacao': return Colors.orange;
      case 'mercado': return Colors.blue;
      case 'moradia': return Colors.purple;
      case 'transporte': return Colors.indigo;
      case 'lazer': return Colors.pink;
      case 'saude': return Colors.red;
      case 'educacao': return Colors.teal;
      default: return Colors.grey;
    }
  }
}
