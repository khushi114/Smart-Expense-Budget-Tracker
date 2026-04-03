/// HomeScreen – Landing screen with title and navigation buttons.

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _expenseCount = 0;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final expenses = await DatabaseHelper.instance.getAllExpenses();
    double total = 0;
    for (final e in expenses) {
      total += e.amount;
    }
    if (mounted) {
      setState(() {
        _expenseCount = expenses.length;
        _totalAmount = total;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF1E88E5), Color(0xFF42A5F5)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ── Header ────────────────────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.logout, color: Colors.white),
                              onPressed: () async {
                                await AuthService.logout();
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(context, '/login');
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 72,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Smart Expense Tracker',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Track your expenses with ease',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ── Summary Cards ─────────────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              Expanded(
                                child: _SummaryCard(
                                  label: 'Total Expenses',
                                  value: '$_expenseCount',
                                  icon: Icons.receipt_long,
                                  iconColor: const Color(0xFF1565C0),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _SummaryCard(
                                  label: 'Total Spent',
                                  value: '₹${_totalAmount.toStringAsFixed(2)}',
                                  icon: Icons.currency_rupee,
                                  iconColor: const Color(0xFF1565C0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ── Action Buttons ─────────────────────────────────────────────
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'What would you like to do?',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1A1A2E),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 28),

                                // Add Expense Button
                                _ActionButton(
                                  icon: Icons.add_circle_outline,
                                  label: 'Add Expense',
                                  subtitle: 'Record a new expense entry',
                                  color: const Color(0xFF1565C0),
                                  onTap: () async {
                                    await Navigator.pushNamed(context, '/add_expense');
                                    _loadSummary();
                                  },
                                ),
                                const SizedBox(height: 16),

                                // View Expenses Button
                                _ActionButton(
                                  icon: Icons.list_alt_rounded,
                                  label: 'View Expenses',
                                  subtitle: 'Browse and manage all expenses',
                                  color: const Color(0xFF1E88E5),
                                  onTap: () async {
                                    await Navigator.pushNamed(context, '/expense_list');
                                    _loadSummary();
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Analytics Button
                                _ActionButton(
                                  icon: Icons.pie_chart,
                                  label: 'Analytics',
                                  subtitle: 'View charts and statistics',
                                  color: const Color(0xFF42A5F5),
                                  onTap: () async {
                                    await Navigator.pushNamed(context, '/analytics');
                                    _loadSummary();
                                  },
                                ),
                                const Spacer(),

                                // Footer
                                const Text(
                                  'All data stored securely on your device',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white30),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
