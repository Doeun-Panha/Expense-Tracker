import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/app_theme.dart';

class CategoryData {
  static const List<Category> categories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Colors.orange,
    ),
    Category(
      id: 'transport',
      name: 'Transportation',
      icon: Icons.directions_bus,
      color: Colors.blue,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Colors.pink,
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Colors.purple,
    ),
    Category(
      id: 'health',
      name: 'Healthcare',
      icon: Icons.medical_services,
      color: AppTheme.income, // Greenish
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long,
      color: Colors.cyan,
    ),
    Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Colors.indigo,
    ),
    Category(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Colors.grey,
    ),
    Category(
      id: 'income',
      name: 'Salary/Income',
      icon: Icons.payments,
      color: AppTheme.income,
    ),
  ];

  static Category getCategoryById(String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => categories.last,
    );
  }
}
