/// AddEditScreen – Screen to add a new expense or edit an existing one.
/// Validates all fields and shows confirmation SnackBar on save.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../database/database_helper.dart';

class AddEditScreen extends StatefulWidget {
  /// If [expense] is provided, the screen is in edit mode.
  final Expense? expense;

  const AddEditScreen({super.key, this.expense});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = ExpenseCategory.values.first;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  bool get _isEditMode => widget.expense != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final e = widget.expense!;
      _titleController.text = e.title;
      _amountController.text = e.amount.toString();
      _selectedCategory = e.category;
      _selectedDate = DateTime.tryParse(e.date) ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // ── Date Picker ────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ── Save Handler ───────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final expense = Expense(
      id: widget.expense?.id,
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text.trim()),
      category: _selectedCategory,
      date: DateFormat('yyyy-MM-dd').format(_selectedDate),
    );

    try {
      if (_isEditMode) {
        await DatabaseHelper.instance.updateExpense(expense);
      } else {
        await DatabaseHelper.instance.insertExpense(expense);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditMode
                  ? 'Expense Updated Successfully'
                  : 'Expense Saved Successfully',
            ),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    const blueColor = Color(0xFF1565C0);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Expense' : 'Add Expense'),
        backgroundColor: blueColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Title ──────────────────────────────────────────────────────
              const Text(
                'Expense Title',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Grocery shopping',
                  prefixIcon: const Icon(Icons.title, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: blueColor, width: 2),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Amount ─────────────────────────────────────────────────────
              const Text(
                'Amount (₹)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'e.g. 250.00',
                  prefixIcon: const Icon(Icons.currency_rupee, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: blueColor, width: 2),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(val.trim());
                  if (amount == null) {
                    return 'Please enter a valid number';
                  }
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Category ───────────────────────────────────────────────────
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category, color: blueColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: blueColor, width: 2),
                  ),
                ),
                items: ExpenseCategory.values.map((cat) {
                  final iconCode = ExpenseCategory.icons[cat] ?? 0xe8b8;
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(
                          IconData(iconCode, fontFamily: 'MaterialIcons'),
                          size: 20,
                          color: Color(
                            ExpenseCategory.colors[cat] ?? 0xFF78909C,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(cat),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please select a category';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ── Date ───────────────────────────────────────────────────────
              const Text(
                'Date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: blueColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // ── Save Button ─────────────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_isEditMode ? Icons.update : Icons.save),
                label: Text(
                  _isEditMode ? 'Update' : 'Save',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
