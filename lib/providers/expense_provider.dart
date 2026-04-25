import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction_model.dart';
import '../utils/database_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _error;

  List<Transaction> get transactions => [..._transactions];
  bool get isLoading => _isLoading;
  String? get error => _error;

  ExpenseProvider() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      _transactions = await DatabaseHelper.instance.getAllTransactions();
    } catch (e) {
      _error = 'Failed to load transactions: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  double get totalExpenses {
    return _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0, (sum, tx) => sum + tx.amount);
  }

  double get totalBalance => totalIncome - totalExpenses;

  Future<void> addTransaction({
    required String title,
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String description = '',
  }) async {
    final newTransaction = Transaction(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      date: date,
      type: type,
      categoryId: categoryId,
      description: description,
    );
    
    try {
      await DatabaseHelper.instance.insertTransaction(newTransaction);
      _transactions.add(newTransaction);
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add transaction: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await DatabaseHelper.instance.deleteTransaction(id);
      _transactions.removeWhere((tx) => tx.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete transaction: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(Transaction updatedTx) async {
    try {
      await DatabaseHelper.instance.updateTransaction(updatedTx);
      final index = _transactions.indexWhere((tx) => tx.id == updatedTx.id);
      if (index >= 0) {
        _transactions[index] = updatedTx;
        _transactions.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update transaction: $e';
      notifyListeners();
      rethrow;
    }
  }
  // Filtering logic
  List<Transaction> getFilteredTransactions({
    String? categoryId,
    TransactionType? type,
    DateTime? startDate,
    DateTime? endDate,
    String query = '',
  }) {
    return _transactions.where((tx) {
      final matchesCategory = categoryId == null || tx.categoryId == categoryId;
      final matchesType = type == null || tx.type == type;
      final matchesDate = (startDate == null || tx.date.isAfter(startDate)) &&
                         (endDate == null || tx.date.isBefore(endDate.add(const Duration(days: 1))));
      final matchesQuery = query.isEmpty || 
                          tx.title.toLowerCase().contains(query.toLowerCase()) ||
                          tx.description.toLowerCase().contains(query.toLowerCase());
      
      return matchesCategory && matchesType && matchesDate && matchesQuery;
    }).toList();
  }
}
