import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final date = DateTime.parse('${transaction.date}T${transaction.time}');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white.withOpacity(0.05) 
            : Colors.black.withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Favorite Button
              IconButton(
                icon: Icon(
                  transaction.favorite ? Icons.star : Icons.star_border,
                  color: transaction.favorite ? AppTheme.accent : Colors.grey,
                ),
                onPressed: () {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .toggleFavorite(transaction.id, transaction.favorite);
                },
              ),
              const SizedBox(width: 8),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction.category.toUpperCase()} • ${dateFormat.format(date)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Text(
                '${isIncome ? '+' : '-'}${currencyFormat.format(transaction.value)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isIncome ? AppTheme.primaryLight : AppTheme.danger,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
