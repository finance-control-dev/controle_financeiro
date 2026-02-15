import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class AddTransactionModal extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionModal({super.key, this.transaction});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late TextEditingController _valueController;
  late TextEditingController _descriptionController;
  late String _category;
  late DateTime _selectedDate;
  bool _isFavorite = false;

  final List<String> _categories = [
    'alimentacao', 'mercado', 'moradia', 'transporte', 'lazer', 'saude', 'educacao', 'salario', 'investimentos', 'outros'
  ];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _type = tx?.type ?? 'expense';
    _valueController = TextEditingController(text: tx?.value.toString() ?? '');
    _descriptionController = TextEditingController(text: tx?.description ?? '');
    _category = tx?.category ?? 'outros';
    _selectedDate = tx?.date ?? DateTime.now();
    _isFavorite = tx?.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context, listen: false).user;

    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.transaction == null ? 'Nova Transação' : 'Editar',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Receita'),
                          selected: _type == 'income',
                          onSelected: (val) => setState(() => _type = 'income'),
                          selectedColor: AppTheme.primaryContainer,
                          checkmarkColor: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Despesa'),
                          selected: _type == 'expense',
                          onSelected: (val) => setState(() => _type = 'expense'),
                          selectedColor: AppTheme.error.withOpacity(0.2),
                          checkmarkColor: AppTheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Valor',
                      prefixText: 'R\$ ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? 'Informe o valor' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? 'Informe a descrição' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c.toUpperCase()))).toList(),
                    onChanged: (val) => setState(() => _category = val!),
                    decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text('Data: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                  ),
                   CheckboxListTile(
                    title: const Text('Favorito'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val!),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final tx = TransactionModel(
                    id: widget.transaction?.id ?? '',
                    userId: user!.uid,
                    type: _type,
                    value: double.parse(_valueController.text.replaceAll(',', '.')),
                    category: _category,
                    description: _descriptionController.text,
                    date: _selectedDate,
                    isFavorite: _isFavorite,
                  );

                  if (widget.transaction == null) {
                    transactionProvider.addTransaction(tx);
                  } else {
                    transactionProvider.updateTransaction(tx);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}
