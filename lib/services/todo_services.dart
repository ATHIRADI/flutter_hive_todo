import 'package:hive/hive.dart';
import 'package:todo_list/models/todo_model.dart';

class TodoServices {
  Future<Box<TodoModel>> get _box async =>
      await Hive.openBox<TodoModel>('todoBox');

  Future<void> addTodos(TodoModel todo) async {
    final box = await _box;
    await box.add(todo);
  }

  Future<List<TodoModel>> allTodos() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> deleteTodos(int index) async {
    final box = await _box;
    box.deleteAt(index);
  }

  Future<void> updateTodos(int index, TodoModel todo) async {
    final box = await _box;
    todo.isDone = !todo.isDone;
    await box.putAt(index, todo);
  }
}
