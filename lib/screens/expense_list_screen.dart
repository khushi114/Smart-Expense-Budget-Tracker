/// ExpenseListScreen – Displays all expenses with edit and delete options.

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/expense_model.dart';
import '../screens/add_edit_screen.dart';
import '../widgets/expense_tile.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  List<Expense> _expenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // ── Data Loading ───────────────────────────────────────────────────────────

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    final expenses = await DatabaseHelper.instance.getAllExpenses();
    if (mounted) {
      setState(() {
        _expenses = expenses;
        _isLoading = false;
      });
    }
  }

  // ── Edit Handler ───────────────────────────────────────────────────────────

  Future<void> _editExpense(Expense expense) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditScreen(expense: expense),
      ),
    );
    if (result == true) {
      _loadExpenses();
    }
  }

  // ── Delete Handler ─────────────────────────────────────────────────────────

  Future<void> _confirmDelete(Expense expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Delete Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${expense.title}"?\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && expense.id != null) {
      await DatabaseHelper.instance.deleteExpense(expense.id!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Expense deleted successfully'),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
      _loadExpenses();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Calculate total
    final total = _expenses.fold<double>(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Expenses'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExpenses,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _expenses.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // ── Total Bar ──────────────────────────────────────────
                    _TotalBar(
                      count: _expenses.length,
                      total: total,
                    ),
                    // ── List ───────────────────────────────────────────────
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadExpenses,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _expenses.length,
                          itemBuilder: (ctx, i) {
                            final expense = _expenses[i];
                            return ExpenseTile(
                              expense: expense,
                              onEdit: () => _editExpense(expense),
                              onDelete: () => _confirmDelete(expense),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddEditScreen()),
          );
          if (result == true) _loadExpenses();
        },
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add New'),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 72,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Expenses Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tap the "Add New" button below\nto record your first expense.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _TotalBar extends StatelessWidget {
  final int count;
  final double total;

  const _TotalBar({required this.count, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$count ${count == 1 ? "record" : "records"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
