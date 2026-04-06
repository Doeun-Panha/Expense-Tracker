import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/summary_widgets.dart';
import '../widgets/transaction_item.dart';
import '../widgets/expense_charts.dart';
import '../utils/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<ExpenseProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()));
              }

              if (provider.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 12),
                        Text(provider.error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                        TextButton(onPressed: provider.loadTransactions, child: const Text('Retry')),
                      ],
                    ),
                  ),
                );
              }

              final latestTransactions = provider.transactions.take(5).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  SummaryCard(
                    title: 'Total Balance',
                    amount: '\$${provider.totalBalance.toStringAsFixed(2)}',
                    color: AppTheme.balance,
                    icon: Icons.account_balance_wallet,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Income',
                          amount: '\$${provider.totalIncome.toStringAsFixed(2)}',
                          color: AppTheme.income,
                          icon: Icons.trending_up,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Expenses',
                          amount: '\$${provider.totalExpenses.toStringAsFixed(2)}',
                          color: AppTheme.expense,
                          icon: Icons.trending_down,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Expenses by Category', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: CategoryPieChart(transactions: provider.transactions),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  if (latestTransactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.receipt_long, size: 48, color: AppTheme.textSecondary.withOpacity(0.5)),
                            const SizedBox(height: 12),
                            const Text('No transactions yet.', style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...latestTransactions.map((tx) => TransactionItem(transaction: tx)),
                  const SizedBox(height: 24),
                  const SizedBox(height: 80), // Space for FAB
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
