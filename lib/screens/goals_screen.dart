import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';
import '../models/goal_model.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Metas')),
      body: transactionProvider.goals.isEmpty
          ? const Center(child: Text('Nenhuma meta cadastrada'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactionProvider.goals.length,
              itemBuilder: (context, index) {
                final goal = transactionProvider.goals[index];
                return _GoalItem(goal: goal);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(context: context, builder: (ctx) => const AddGoalDialog());
  }
}

class _GoalItem extends StatelessWidget {
  final GoalModel goal;
  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(goal.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('${(progress * 100).toStringAsFixed(1)}%', 
                     style: TextStyle(fontWeight: FontWeight.bold, color: progress >= 1 ? AppTheme.primary : AppTheme.secondary)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              color: progress >= 1 ? AppTheme.primary : AppTheme.secondary,
              backgroundColor: Colors.grey[200],
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currencyFormat.format(goal.currentAmount), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Meta: ${currencyFormat.format(goal.targetAmount)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddGoalDialog extends StatefulWidget {
  const AddGoalDialog({super.key});

  @override
  State<AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<AddGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return AlertDialog(
      title: const Text('Nova Meta'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Meta (R\$)'),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              TextFormField(
                controller: _currentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Atual (R\$)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final goal = GoalModel(
                id: '', // Firestore generates
                userId: user!.uid,
                description: _descController.text,
                targetAmount: double.parse(_targetController.text.replaceAll(',', '.')),
                currentAmount: double.tryParse(_currentController.text.replaceAll(',', '.')) ?? 0.0,
                order: DateTime.now().millisecondsSinceEpoch,
              );
              transactionProvider.addGoal(goal);
              Navigator.pop(context);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
