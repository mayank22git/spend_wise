class Todo {
  Todo({
    required this.title,
    this.isDone = false,
    required this.createdAt,
  });

  final String title;
  bool isDone;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    final String? createdString = json['createdAt'] as String?;

    return Todo(
      title: (json['title'] ?? '').toString(),
      isDone: json['isDone'] == true,
      createdAt: createdString != null
          ? DateTime.parse(createdString)
          : DateTime.now(),
    );
  }
}