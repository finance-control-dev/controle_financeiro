import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_card.dart';
import '../widgets/add_transaction_modal.dart';
import '../theme/app_theme.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    transactionProvider.setFilters(description: '');
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => transactionProvider.setFilters(description: val),
            ),
          ),
          Expanded(
            child: transactionProvider.transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação encontrada'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactionProvider.transactions.length,
                    itemBuilder: (ctx, index) {
                      final tx = transactionProvider.transactions[index];
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

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Filtrar por Tipo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: AppTheme.primary),
                title: const Text('Receitas'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false).setFilters(type: 'income');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: AppTheme.error),
                title: const Text('Despesas'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false).setFilters(type: 'expense');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Limpar Filtro'),
                onTap: () {
                  Provider.of<TransactionProvider>(context, listen: false).clearFilters();
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
