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

Map<String, dynamic> toJson() {
  return <String, dynamic>{
    'title': title,
    'amount': amount,
    'category': category.name,
    'date': date.toString(),
  };
}

factory Expense.fromJson(Map<String, dynamic> json) {
  final String categoryName = (json['category'] ?? 'food').toString();
  final ExpenseCategory category = ExpenseCategory.values.firstWhere(
    (ExpenseCategory item) => item.name == categoryName,
  orElse: () => ExpenseCategory.food,
  );

final dynamic amountValue = json['amount'];
final double amount = amountValue is num
    ? amountValue.toDouble()
    : double.tryParse(amountValue.toString()) ?? 0;

final String? dateString = json['date'] as String?;
final DateTime date =
dateString != null ? DateTime.parse(dateString) : DateTime.now();

return Expense(
title: (json['title'] ?? '').toString(),
amount: amount,
category: category,
date: date,
);
}
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