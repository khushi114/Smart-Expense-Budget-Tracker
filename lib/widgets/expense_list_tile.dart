/// ExpenseListTile – row item for an Expense in the Recent Expenses list.
/// Shows category icon, title, date, and amount with a swipe-to-delete.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';

class ExpenseListTile extends StatelessWidget {
  /// The expense data to display
  final Expense expense;

  /// Callback invoked when the user confirms deletion
  final VoidCallback onDelete;

  const ExpenseListTile({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        Color(ExpenseCategory.colors[expense.category] ?? 0xFF78909C);
    final iconData = IconData(
      ExpenseCategory.icons[expense.category] ?? 0xe8b8,
      fontFamily: 'MaterialIcons',
    );

    // Parse date for display
    DateTime? date;
    try {
      date = DateTime.parse(expense.date);
    } catch (_) {}

    return Dismissible(
      key: Key('expense_${expense.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF5350),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      // Ask for confirmation before deleting
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: Text('Delete expense?',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                content: Text(
                  '"${expense.title}" – ₹${expense.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5350),
                        foregroundColor: Colors.white),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onDelete(),

      // ── Tile content ──────────────────────────────────────────────────────
      child: Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.14),
            child: Icon(iconData, color: color, size: 22),
          ),
          title: Text(
            expense.title,
            style: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${expense.category}  •  ${date != null ? DateFormat('dd MMM yyyy').format(date) : expense.date}',
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
          ),
          trailing: Text(
            '₹${expense.amount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF5350),
            ),
          ),
        ),
      ),
    );
  }
}
