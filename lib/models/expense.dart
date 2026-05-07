enum ExpenseCategory { food, transport, fun }

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
}

extension ExpenseCategoryLabel on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.fun:
        return 'Fun';
    }
  }
}