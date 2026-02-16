import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Nenhuma transação ainda.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final transaction = transactions[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TransactionItem(transaction: transaction),
          );
        },
        childCount: transactions.length,
      ),
    );
  }
}
