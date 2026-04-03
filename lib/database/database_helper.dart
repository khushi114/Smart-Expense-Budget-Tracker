/// DatabaseHelper – Web-compatible storage using shared_preferences.
/// Provides same CRUD API as a SQLite helper so screens need no changes.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _kKey = 'expenses';

  // ── Internal helpers ───────────────────────────────────────────────────────

  Future<List<Expense>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Expense.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> _saveAll(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, jsonEncode(expenses.map((e) => e.toMap()).toList()));
  }

  int _nextId(List<Expense> list) {
    if (list.isEmpty) return 1;
    return list.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<int> insertExpense(Expense expense) async {
    final all = await _loadAll();
    final id = _nextId(all);
    all.add(expense.copyWith(id: id));
    await _saveAll(all);
    return id;
  }

  Future<List<Expense>> getAllExpenses() async {
    final all = await _loadAll();
    all.sort((a, b) {
      final c = b.date.compareTo(a.date);
      return c != 0 ? c : (b.id ?? 0).compareTo(a.id ?? 0);
    });
    return all;
  }

  Future<int> updateExpense(Expense expense) async {
    final all = await _loadAll();
    final idx = all.indexWhere((e) => e.id == expense.id);
    if (idx == -1) return 0;
    all[idx] = expense;
    await _saveAll(all);
    return 1;
  }

  Future<int> deleteExpense(int id) async {
    final all = await _loadAll();
    final before = all.length;
    all.removeWhere((e) => e.id == id);
    await _saveAll(all);
    return before - all.length;
  }
}
