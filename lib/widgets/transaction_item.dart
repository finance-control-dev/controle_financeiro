import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final isIncome = transaction.type == 'income';
    final theme = Theme.of(context);
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        provider.deleteTransaction(transaction.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transação removida')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isIncome
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: isIncome ? theme.colorScheme.primary : theme.colorScheme.error,
            ),
          ),
          title: Text(
            transaction.description,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${transaction.category} • ${DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.date))}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currencyFormat.format(transaction.value),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? theme.colorScheme.primary : theme.colorScheme.error,
                ),
              ),
            ],
          ),
          onTap: () {
            // Edit transaction?
          },
        ),
      ),
    );
  }
}
