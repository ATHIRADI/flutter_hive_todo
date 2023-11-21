import 'package:flutter/material.dart';
import 'package:todo_list/data/todo_list.dart';
import 'package:todo_list/models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TextEditingController addTodoController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    addTodoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: SafeArea(
        child: _showingList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlert(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _showingList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(todos[index]["todo_item"].toString(),
              style: todos[index]["is_done"] == true
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontWeight: FontWeight.bold)),
          leading: Checkbox(
            value: todos[index]["is_done"],
            onChanged: (value) {
              setState(
                () {
                  todos[index]["is_done"] = !todos[index]["is_done"];
                },
              );
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                todos.remove(todos[index]);
              });
            },
          ),
        );
      },
    );
  }

  _showAlert(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text("Add Todo"),
            content: TextFormField(
              decoration: const InputDecoration(
                hintText: "Todo . . . . ",
              ),
              controller: addTodoController,
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  if (addTodoController.text.isNotEmpty) {
                    final singleTodo = TodoMedel(
                      todoItem: addTodoController.text,
                      isDone: false,
                      time: DateTime.now(),
                    ).toMap();
                    addingTodos(singleTodo);
                  }
                  Navigator.of(context).pop();
                  addTodoController.clear();
                },
              )
            ]);
      },
    );
  }

  void addingTodos(singleTodo) {
    setState(() {
      todos.add(singleTodo);
    });
  }
}
