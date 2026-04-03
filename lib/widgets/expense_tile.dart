/// ExpenseTile – A reusable card widget for displaying a single expense.
/// Shows title, amount, category (with icon), and date.
/// Provides edit and delete action icons.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final iconCode = ExpenseCategory.icons[expense.category] ?? 0xe8b8;
    final colorHex = ExpenseCategory.colors[expense.category] ?? 0xFF78909C;
    final categoryColor = Color(colorHex);

    // Format date nicely
    String formattedDate = expense.date;
    try {
      final dt = DateTime.parse(expense.date);
      formattedDate = DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {}

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            IconData(iconCode, fontFamily: 'MaterialIcons'),
            color: categoryColor,
            size: 26,
          ),
        ),
        title: Text(
          expense.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    expense.category,
                    style: TextStyle(
                      fontSize: 11,
                      color: categoryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 11, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Amount
            Text(
              '₹${expense.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(width: 4),
            // Edit icon
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: Color(0xFF1565C0)),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            // Delete icon
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
