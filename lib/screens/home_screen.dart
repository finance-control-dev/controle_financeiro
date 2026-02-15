import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_card.dart';
import '../widgets/custom_drawer.dart';
import '../theme/app_theme.dart';
import 'add_transaction_modal.dart';
import 'transactions_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Initial fetch handled by ProxyProvider updates in main.dart

    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá,',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Text(
              user?.displayName ?? 'Usuário',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                user?.photoURL ??
                    'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y',
              ),
            ),
          ),
        ],
      ),
      body: transactionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                 // Trigger refresh logic if needed, currently streams auto-update
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Summary Cards
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(
                          width: 160,
                          child: SummaryCard(
                            title: 'Entradas',
                            value: currencyFormat.format(transactionProvider.totalIncome),
                            icon: Icons.arrow_upward_rounded,
                            color: AppTheme.primaryLight,
                            backgroundColor: AppTheme.primary.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
                          child: SummaryCard(
                            title: 'Saídas',
                            value: currencyFormat.format(transactionProvider.totalExpense),
                            icon: Icons.arrow_downward_rounded,
                            color: AppTheme.danger,
                            backgroundColor: AppTheme.danger.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 160,
                          child: SummaryCard(
                            title: 'Saldo',
                            value: currencyFormat.format(transactionProvider.balance),
                            icon: Icons.account_balance_wallet_rounded,
                            color: AppTheme.accent,
                            backgroundColor: AppTheme.accent.withOpacity(0.1),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Recent Transactions Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                          );
                        },
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Transactions List (Limit to 5)
                  if (transactionProvider.transactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('Nenhuma transação recente'),
                      ),
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
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
