import 'package:flutter/material.dart';
import 'package:spend_wise/models/expense.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_card.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    super.key,
    required this.expenses,
    required this.onAddExpense,
    required this.onDeleteExpense,
  });

  final List<Expense> expenses;
  final ValueChanged<Expense> onAddExpense;
  final ValueChanged<int> onDeleteExpense;

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  DateTime _selectedDate = DateTime.now();
  DateTime? _filterDate;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1, now.month, now.day);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectFilterDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _filterDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    setState(() {
      _filterDate = picked;
    });
  }

  void _submitExpense() {
    final String title = _titleController.text.trim();
    final double? amount = double.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid title and amount greater than 0.'),
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: _selectedDate,
      ),
    );

    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = ExpenseCategory.food;
      _selectedDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Expense> displayedExpenses = _filterDate == null
        ? widget.expenses
        : widget.expenses.where((Expense e) {
      return e.date.year == _filterDate!.year &&
          e.date.month == _filterDate!.month &&
          e.date.day == _filterDate!.day;
    }).toList();

    final double total = displayedExpenses.fold<double>(
      0,
          (double sum, Expense item) => sum + item.amount,
    );

    return Column(
      children: [
        // ── ADD EXPENSE FORM ──────────────────────────────────────
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Expense title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<ExpenseCategory>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: ExpenseCategory.values
                            .map(
                              (ExpenseCategory category) =>
                              DropdownMenuItem<ExpenseCategory>(
                                value: category,
                                child: Text(category.label),
                              ),
                        )
                            .toList(),
                        onChanged: (ExpenseCategory? value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Selected Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Choose Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submitExpense,
                    child: const Text('Add expense'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── TOTAL + FILTER ROW ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _filterDate == null ? 'Total spent' : 'Spent on this day',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '₹${total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const Spacer(),
              if (_filterDate != null)
                TextButton(
                  onPressed: () => setState(() => _filterDate = null),
                  child: const Text('Clear Filter'),
                ),
              IconButton(
                onPressed: _selectFilterDate,
                icon: Icon(
                  _filterDate == null
                      ? Icons.filter_alt_outlined
                      : Icons.filter_alt,
                  color: _filterDate == null ? null : Colors.teal,
                ),
                tooltip: 'Filter by date',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── EXPENSE LIST ─────────────────────────────────────────
        Expanded(
          child: displayedExpenses.isEmpty
              ? Center(
            child: Text(
              _filterDate == null
                  ? 'No expenses yet. Add your first one above.'
                  : 'No expenses found for this date.',
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: displayedExpenses.length,
            itemBuilder: (BuildContext context, int index) {
              final Expense expense = displayedExpenses[index];
              return Dismissible(
                key: ValueKey<Expense>(expense),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  final int originalIndex =
                  widget.expenses.indexOf(expense);
                  widget.onDeleteExpense(originalIndex);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ExpenseCard(expense: expense),
              );
            },
          ),
        ),
      ],
    );
  }
}
