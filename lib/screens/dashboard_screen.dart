import 'package:flutter/material.dart';
import 'package:spend_wise/models/expense.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:spend_wise/widgets/dashboard_metric_card.dart';

class DashboardScreen extends StatelessWidget {
const DashboardScreen({
super.key,
required this.expenses,
required this.todos,
});

final List<Expense> expenses;
final List<Todo> todos;

@override
Widget build(BuildContext context) {
final DateTime now = DateTime.now();

final double totalSpent = expenses.fold<double>(
0,
(double sum, Expense item) => sum + item.amount,
);

final double todaySpent = expenses
.where(
(Expense item) =>
item.date.year == now.year &&
item.date.month == now.month &&
item.date.day == now.day,
)
.fold<double>(0, (double sum, Expense item) => sum + item.amount);

final int doneCount =
todos.where((Todo item) => item.isDone).length;

final int todayTasks = todos
.where(
(Todo item) =>
item.createdAt.year == now.year &&
item.createdAt.month == now.month &&
item.createdAt.day == now.day,
)
.length;


return Scaffold(
appBar: AppBar(title: const Text('Dashboard')),
body: ListView(
padding: const EdgeInsets.all(12),
children: [
DashboardMetricCard(
label: 'Total spent',
value: '₹${totalSpent.toStringAsFixed(2)}',
icon: Icons.account_balance_wallet_outlined,
color: Colors.teal,
),
DashboardMetricCard(
label: "Today's spending",
value: '₹${todaySpent.toStringAsFixed(2)}',
icon: Icons.today_outlined,
color: Colors.blue,
),
DashboardMetricCard(
label: 'Tasks done',
value: '$doneCount / ${todos.length}',
icon: Icons.check_circle_outline,
color: Colors.green,
),
DashboardMetricCard(
label: 'Tasks added today',
value: '$todayTasks',
  icon: Icons.playlist_add_check_outlined,
  color: Colors.orange,
),
],
),
);
}
}