import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import '../theme/app_theme.dart';
import 'add_transaction_modal.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
               _showFilterModal(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por descrição...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                     _searchController.clear();
                     transactionProvider.setFilters(description: '');
                  },
                ),
              ),
              onChanged: (value) {
                transactionProvider.setFilters(description: value);
              },
            ),
          ),

          // Transaction List
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação encontrada'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return TransactionCard(
                        transaction: tx,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => AddTransactionModal(transaction: tx),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtrar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Implement filter options here (Type, Date, Category)
              // For brevity, just a clear button for now or simple toggles
               ListTile(
                leading: const Icon(Icons.arrow_circle_up, color: AppTheme.primary),
                title: const Text('Apenas Receitas'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .setFilters(type: 'income');
                  Navigator.pop(context);
                },
              ),
               ListTile(
                leading: const Icon(Icons.arrow_circle_down, color: AppTheme.danger),
                title: const Text('Apenas Despesas'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .setFilters(type: 'expense');
                  Navigator.pop(context);
                },
              ),
              const Divider(),
               ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Limpar Filtros'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .clearFilters();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
