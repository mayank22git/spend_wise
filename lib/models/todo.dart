class Todo {
  Todo({
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  final String title;
  bool isDone;
  final DateTime createdAt;
}