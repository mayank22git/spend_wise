import 'package:flutter/material.dart';
import 'package:spend_wise/models/todo.dart';
import 'package:spend_wise/widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({
    super.key,
    required this.todos,
    required this.onAddTodo,
    required this.onToggleTodo,
    required this.onDeleteTodo,
  });

  final List<Todo> todos;
  final ValueChanged<String> onAddTodo;
  final ValueChanged<int> onToggleTodo;
  final ValueChanged<int> onDeleteTodo;

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _submitTodo() {
    final String taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task cannot be empty.')));
      return;
    }
    widget.onAddTodo(taskTitle);
    _taskController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── ADD TASK FORM ─────────────────────────────────────────
        Card(
          margin: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'New task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _submitTodo(),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: _submitTodo,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ),

        // ── TODO LIST ─────────────────────────────────────────────
        Expanded(
          child: widget.todos.isEmpty
              ? const Center(
            child: Text('No tasks yet. Add one to get started.'),
          )
              : ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: widget.todos.length,
            itemBuilder: (BuildContext context, int index) {
              final Todo todo = widget.todos[index];
              return Dismissible(
                key: ValueKey<Todo>(todo),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => widget.onDeleteTodo(index),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: TodoTile(
                  todo: todo,
                  onChanged: (_) => widget.onToggleTodo(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}