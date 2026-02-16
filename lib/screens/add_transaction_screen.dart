import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _type = 'expense';
  String _category = 'Outros';

  // Mock categories
  final List<String> _categories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Educação',
    'Lazer',
    'Saúde',
    'Salário',
    'Outros'
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_descriptionController.text.isEmpty || _valueController.text.isEmpty) {
      return;
    }

    final enteredDescription = _descriptionController.text;
    final enteredValue = double.tryParse(_valueController.text.replaceAll(',', '.')) ?? 0.0;

    if (enteredValue <= 0) {
      return;
    }

    final newTransaction = Transaction(
      id: const Uuid().v4(),
      description: enteredDescription,
      value: enteredValue,
      category: _category,
      date: _selectedDate.toString().split(' ')[0],
      type: _type,
      userId: 'test_user', // Fixed for now
    );

    Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = _type == 'income';
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTypeButton('Receita', 'income', Colors.green),
                const SizedBox(width: 16),
                _buildTypeButton('Despesa', 'expense', Colors.red),
              ],
            ),
            const SizedBox(height: 20),
            
            // Value Input
            TextField(
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.cardTheme.color,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Description Input
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: theme.cardTheme.color,
              ),
            ),
            const SizedBox(height: 16),

            // Category & Date Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _category = val!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: theme.cardTheme.color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _presentDatePicker,
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Data',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: theme.cardTheme.color,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                          const Icon(Icons.calendar_today, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Salvar Transação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String value, Color color) {
    final isSelected = _type == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _type = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
