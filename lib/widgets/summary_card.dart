import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const SummaryCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Total',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(balance),
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(
                context,
                'Receita',
                income,
                theme.colorScheme.primary,
                Icons.arrow_upward,
              ),
              _buildInfoColumn(
                context,
                'Despesa',
                expense,
                theme.colorScheme.error,
                Icons.arrow_downward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(
    BuildContext context,
    String label,
    double value,
    Color color,
    IconData icon,
  ) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            Text(
              currencyFormat.format(value),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
