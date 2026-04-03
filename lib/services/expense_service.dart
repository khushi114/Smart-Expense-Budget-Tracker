/// ExpenseService – business-logic layer between UI and DatabaseHelper.
/// Keeps screens clean by delegating all DB calls here.

import '../database/database_helper.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // ── Write Operations ───────────────────────────────────────────────────────

  /// Persist a new expense. Returns the new row id.
  Future<int> addExpense(Expense expense) => _db.insertExpense(expense);

  /// Update an existing expense. Returns number of rows affected.
  Future<int> updateExpense(Expense expense) => _db.updateExpense(expense);

  /// Remove an expense by [id]. Returns number of rows affected.
  Future<int> deleteExpense(int id) => _db.deleteExpense(id);

  // ── Read Operations ────────────────────────────────────────────────────────

  /// Fetch all expenses (most recent first).
  Future<List<Expense>> getAllExpenses() => _db.getAllExpenses();

  /// Fetch expenses for a given [month] ("yyyy-MM").
  Future<List<Expense>> getMonthlyExpenses(String month) =>
      _db.getExpensesByMonth(month);

  /// Total expenditure for [month].
  Future<double> getMonthlyTotal(String month) => _db.getTotalByMonth(month);

  /// Spending per category for [month].
  Future<Map<String, double>> getCategoryBreakdown(String month) =>
      _db.getCategoryTotals(month);

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Returns today's date formatted as "yyyy-MM-dd".
  static String todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  /// Returns the current month formatted as "yyyy-MM".
  static String currentMonthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }
}
