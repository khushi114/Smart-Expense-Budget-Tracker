/// Expense model – represents a single expense entry.
/// Contains helpers to convert to/from SQLite row maps.

class Expense {
  /// Auto-incremented primary key (null when creating a new record)
  final int? id;

  /// Short description, e.g. "Grocery shopping"
  final String title;

  /// Amount spent (stored as REAL in SQLite)
  final double amount;

  /// Category label: Food, Transport, Shopping, etc.
  final String category;

  /// ISO-8601 date string "yyyy-MM-dd"
  final String date;

  const Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // ── Serialization ──────────────────────────────────────────────────────────

  /// Convert model → SQLite row map (excludes id so SQLite auto-increments)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  /// Convert SQLite row map → model
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
    );
  }

  /// Create a copy with optional overridden fields
  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    String? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date)';
}

/// Predefined categories for consistent UI rendering.
class ExpenseCategory {
  const ExpenseCategory._();

  static const List<String> values = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Other',
  ];

  /// Maps category name → Material icon data code point
  static const Map<String, int> icons = {
    'Food': 0xe56c,          // restaurant
    'Transport': 0xe531,     // directions_car
    'Shopping': 0xe8cc,      // shopping_cart
    'Bills': 0xe850,         // receipt
    'Entertainment': 0xe02c, // movie
    'Other': 0xe8b8,         // attach_money
  };

  /// Maps category name → color hex value
  static const Map<String, int> colors = {
    'Food': 0xFFEF5350,
    'Transport': 0xFF42A5F5,
    'Shopping': 0xFFAB47BC,
    'Bills': 0xFFFF7043,
    'Entertainment': 0xFFEC407A,
    'Other': 0xFF78909C,
  };
}
