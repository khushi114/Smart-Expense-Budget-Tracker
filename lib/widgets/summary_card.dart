/// SummaryCard – compact stat card shown on the Home Dashboard.
/// Displays a label, formatted currency amount, and a colour-coded icon.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryCard extends StatelessWidget {
  /// Card heading, e.g. "Budget", "Spent", "Left"
  final String label;

  /// Monetary value to display
  final double amount;

  /// Material icon for this card
  final IconData icon;

  /// Accent colour used for the icon circle and value text
  final Color color;

  /// Optional tap callback (e.g. open budget editor)
  final VoidCallback? onTap;

  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            children: [
              // ── Icon circle ─────────────────────────────────────────────────
              CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                radius: 22,
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),

              // ── Amount ──────────────────────────────────────────────────────
              FittedBox(
                child: Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              // ── Label ───────────────────────────────────────────────────────
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
