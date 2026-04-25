import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/transaction_item.dart';
import '../utils/app_theme.dart';
import '../models/transaction_model.dart';
import '../models/category_data.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _searchQuery = '';
  String? _selectedCategoryId;
  TransactionType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _selectedCategoryId,
                        decoration: const InputDecoration(labelText: 'Category', contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Categories')),
                          ...CategoryData.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name))),
                        ],
                        onChanged: (val) => setState(() => _selectedCategoryId = val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<TransactionType?>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: 'Type', contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All Types')),
                          DropdownMenuItem(value: TransactionType.income, child: Text('Income')),
                          DropdownMenuItem(value: TransactionType.expense, child: Text('Expense')),
                        ],
                        onChanged: (val) => setState(() => _selectedType = val),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text(provider.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        TextButton(onPressed: provider.loadTransactions, child: const Text('Retry')),
                      ],
                    ),
                  );
                }

                final transactions = provider.getFilteredTransactions(
                  categoryId: _selectedCategoryId,
                  type: _selectedType,
                  query: _searchQuery,
                );

                if (transactions.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppTheme.textSecondary),
                        SizedBox(height: 16),
                        Text('No matches found.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return TransactionItem(
                      transaction: tx,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddTransactionScreen(transaction: tx)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
