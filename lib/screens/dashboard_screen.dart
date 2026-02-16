import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/chart_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Despesas por Categoria',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            ChartWidget(transactions: transactions),
            const SizedBox(height: 40),
            // Add more charts or stats here
          ],
        ),
      ),
    );
  }
}
