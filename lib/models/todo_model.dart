import 'package:hive/hive.dart';

part "todo_model.g.dart";

@HiveType(typeId: 1)
class TodoModel {
  @HiveField(0)
  final String todoItem;
  @HiveField(1)
  bool isDone;
  @HiveField(2)
  final DateTime time;

  TodoModel({
    required this.todoItem,
    required this.isDone,
    required this.time,
  });
}
