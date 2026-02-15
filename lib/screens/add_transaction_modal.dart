import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
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
    'alimentacao',
    'mercado',
    'combustivel',
    'manutencao_veiculo',
    'transporte',
    'moradia',
    'saude',
    'educacao',
    'lazer',
    'salario',
    'freelance',
    'investimentos',
    'outros'
  ];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _type = tx?.type ?? 'expense';
    _valueController = TextEditingController(text: tx?.value.toString() ?? '');
    _descriptionController = TextEditingController(text: tx?.description ?? '');
    _category = tx?.category ?? 'outros';
    _selectedDate = tx != null ? DateTime.parse(tx.date) : DateTime.now();
    _isFavorite = tx?.favorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.transaction == null ? 'Nova Transação' : 'Editar Transação',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Type Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _type = 'income'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _type == 'income'
                                    ? AppTheme.primary.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: _type == 'income'
                                    ? Border.all(color: AppTheme.primary)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Receita',
                                  style: TextStyle(
                                    color: _type == 'income'
                                        ? AppTheme.primary
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _type = 'expense'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _type == 'expense'
                                    ? AppTheme.danger.withOpacity(0.2)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: _type == 'expense'
                                    ? Border.all(color: AppTheme.danger)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Despesa',
                                  style: TextStyle(
                                    color: _type == 'expense'
                                        ? AppTheme.danger
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Value Input
                  TextFormField(
                    controller: _valueController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _type == 'income' ? AppTheme.primary : AppTheme.danger,
                    ),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      prefixText: 'R\$ ',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Informe o valor';
                      if (double.tryParse(value) == null) return 'Valor inválido';
                      return null;
                    },
                  ),
                  
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Informe a descrição' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => _category = value!),
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Data',
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                   // Favorite
                  SwitchListTile(
                    title: const Text('Favoritar transação'),
                    value: _isFavorite,
                    onChanged: (val) => setState(() => _isFavorite = val),
                    secondary: const Icon(Icons.star),
                    contentPadding: EdgeInsets.zero,
                  ),

                ],
              ),
            ),
          ),
          
          // Action Buttons
          Row(
            children: [
              if (widget.transaction != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                         transactionProvider.deleteTransaction(widget.transaction!.id);
                         Navigator.pop(context);
                      },
                      icon: const Icon(Icons.delete, color: AppTheme.danger),
                      label: const Text('Excluir', style: TextStyle(color: AppTheme.danger)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.danger),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final tx = TransactionModel(
                        id: widget.transaction?.id ?? '', // ID handled by firestore if new
                        userId: user!.uid,
                        type: _type,
                        value: double.parse(_valueController.text.replaceAll(',', '.')),
                        category: _category,
                        description: _descriptionController.text,
                        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                        time: DateFormat('HH:mm').format(DateTime.now()),
                        favorite: _isFavorite,
                        deleted: false,
                      );

                      if (widget.transaction == null) {
                        transactionProvider.addTransaction(tx);
                      } else {
                        transactionProvider.updateTransaction(tx);
                      }
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
