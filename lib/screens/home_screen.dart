import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list.dart';
import '../widgets/summary_card.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 120.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Controle Financeiro'),
              centerTitle: false,
            ),
            actions: [
              IconButton(
                icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SummaryCard(
                balance: transactionProvider.balance,
                income: transactionProvider.totalIncome,
                expense: transactionProvider.totalExpense,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: TransactionList(transactions: transactionProvider.transactions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) {
              return const AddTransactionScreen();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
