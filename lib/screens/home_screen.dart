import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/add_transaction_modal.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const CustomDrawer(),
      body: transactionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                // Provider streams auto-update, but could force refresh here if needed
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Summary Row
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SummaryCard(
                          title: 'Entradas',
                          value: currencyFormat.format(transactionProvider.totalIncome),
                          icon: Icons.arrow_upward,
                          color: AppTheme.primary,
                          backgroundColor: AppTheme.primary.withOpacity(0.1),
                        ),
                        const SizedBox(width: 12),
                        SummaryCard(
                          title: 'Saídas',
                          value: currencyFormat.format(transactionProvider.totalExpense),
                          icon: Icons.arrow_downward,
                          color: AppTheme.error,
                          backgroundColor: AppTheme.error.withOpacity(0.1),
                        ),
                        const SizedBox(width: 12),
                        SummaryCard(
                          title: 'Saldo',
                          value: currencyFormat.format(transactionProvider.balance),
                          icon: Icons.account_balance_wallet,
                          color: AppTheme.secondary,
                          backgroundColor: AppTheme.secondary.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recentes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/transactions'),
                        child: const Text('Ver tudo'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),

                  // List
                  if (transactionProvider.transactions.isEmpty)
                     const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: Text('Nenhuma transação recente')),
                    )
                  else
                    ...transactionProvider.transactions
                        .take(5)
                        .map((tx) => TransactionCard(
                              transaction: tx,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (ctx) => AddTransactionModal(transaction: tx),
                                );
                              },
                            )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => const AddTransactionModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
