class TodoMedel {
  final String todoItem;
  final bool isDone;
  final DateTime time;

  TodoMedel({
    required this.todoItem,
    required this.isDone,
    required this.time,
  });

  toMap() {
    return {
      "todo_item": todoItem,
      "is_done": isDone,
      "time": time,
    };
  }
}
