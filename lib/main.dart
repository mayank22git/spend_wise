import 'package:flutter/material.dart';
import 'package:spend_wise/models/expense.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:spend_wise/screens/expense_screen.dart';
import 'package:spend_wise/screens/todo_screen.dart';

void main() {
  runApp(const SpendWiseApp());
}

class SpendWiseApp extends StatelessWidget {
  const SpendWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpendWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        appBarTheme: const AppBarTheme(centerTitle: false),
      ),
      home: const SpendWiseHome(),
    );
  }
}

class SpendWiseHome extends StatefulWidget {
  const SpendWiseHome({super.key});

  @override
  State<SpendWiseHome> createState() => _SpendWiseHomeState();
}

class _SpendWiseHomeState extends State<SpendWiseHome> {
  int _selectedTab = 0;

  final List<Expense> _expenses = <Expense>[];
  final List<Todo> _todos = <Todo>[];



  @override
  Widget build(BuildContext context) {
    final List<String> titles = <String>['Expenses', 'Todo List'];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectedTab]),
        ),
        body: _selectedTab == 0
            ? const ExpenseScreen()
            : const TodoScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.checklist_outlined),
              label: 'Todo',
            ),
          ],
        ),
      ),
    );
  }
}