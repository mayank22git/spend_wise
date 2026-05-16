import 'package:flutter/material.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:intl/intl.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo, required this.onChanged});

  final Todo todo;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: CheckboxListTile(
        value: todo.isDone,
        onChanged: onChanged,
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Added on ${DateFormat.yMMMd().format(todo.createdAt)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}