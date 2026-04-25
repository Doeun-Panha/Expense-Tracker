import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../models/category_data.dart';
import '../providers/expense_provider.dart';
import '../utils/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _amount;
  late TransactionType _type;
  late String _categoryId;
  late DateTime _selectedDate;
  late String _description;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _title = widget.transaction!.title;
      _amount = widget.transaction!.amount;
      _type = widget.transaction!.type;
      _categoryId = widget.transaction!.categoryId;
      _selectedDate = widget.transaction!.date;
      _description = widget.transaction!.description;
    } else {
      _title = '';
      _amount = 0;
      _type = TransactionType.expense;
      _categoryId = 'food';
      _selectedDate = DateTime.now();
      _description = '';
    }
  }

  bool _isSubmitting = false;

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    try {
      final provider = Provider.of<ExpenseProvider>(context, listen: false);
      
      if (widget.transaction != null) {
        await provider.updateTransaction(Transaction(
          id: widget.transaction!.id,
          title: _title,
          amount: _amount,
          date: _selectedDate,
          type: _type,
          categoryId: _categoryId,
          description: _description,
        ));
      } else {
        await provider.addTransaction(
          title: _title,
          amount: _amount,
          type: _type,
          categoryId: _categoryId,
          date: _selectedDate,
          description: _description,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transaction: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteTransaction() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isSubmitting = true);
      try {
        await Provider.of<ExpenseProvider>(context, listen: false)
            .deleteTransaction(widget.transaction!.id);
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting transaction: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null ? 'Add New Transaction' : 'Edit Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Type', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Expense')),
                      selected: _type == TransactionType.expense,
                      onSelected: _isSubmitting ? null : (val) => setState(() => _type = TransactionType.expense),
                      selectedColor: AppTheme.expense.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Income')),
                      selected: _type == TransactionType.income,
                      onSelected: _isSubmitting ? null : (val) => setState(() => _type = TransactionType.income),
                      selectedColor: AppTheme.income.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _title,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'Title', hintText: 'Rent, Coffee, etc.'),
                validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
                onSaved: (val) => _title = val!,
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _amount == 0 ? '' : _amount.toString(),
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'Amount (\$)', hintText: '0.00'),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || double.tryParse(val) == null ? 'Please enter a valid amount' : null,
                onSaved: (val) => _amount = double.parse(val!),
              ),
              const SizedBox(height: 20),
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _categoryId,
                items: CategoryData.categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Row(
                      children: [
                        Icon(cat.icon, color: cat.color, size: 20),
                        const SizedBox(width: 10),
                        Text(cat.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: _isSubmitting ? null : (val) => setState(() => _categoryId = val!),
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _description,
                enabled: !_isSubmitting,
                decoration: const InputDecoration(labelText: 'Description', hintText: 'Enter description...'),
                maxLines: 2,
                onSaved: (val) => _description = val ?? '',
              ),
              const SizedBox(height: 20),
              const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _isSubmitting ? null : _presentDatePicker,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                    color: _isSubmitting ? Colors.grey[100] : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
                      const Icon(Icons.calendar_month, color: AppTheme.primary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitData,
                  child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(widget.transaction == null ? 'Add Transaction' : 'Update Transaction'),
                ),
              ),
              if (widget.transaction != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isSubmitting ? null : _deleteTransaction,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Delete Transaction'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
