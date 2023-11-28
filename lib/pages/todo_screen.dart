import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/models/todo_model.dart';
import 'package:todo_list/services/todo_services.dart';

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
        child: FutureBuilder(
          future: TodoServices().allTodos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _showingList();
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
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
    return ValueListenableBuilder(
      valueListenable: Hive.box<TodoModel>('todoBox').listenable(),
      builder: (context, Box<TodoModel> box, _) {
        return ListView.separated(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final todo = box.getAt(index);
            return Dismissible(
              key: Key(box.getAt(index).toString()),
              onDismissed: (direction) {
                // Step 2
                setState(() {
                  TodoServices().deleteTodos(index);
                });
              },
              background: Container(color: Colors.amberAccent),
              child: ListTile(
                title: Text(todo!.todoItem,
                    style: todo!.isDone == true
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough)
                        : const TextStyle(fontWeight: FontWeight.bold)),
                leading: Checkbox(
                  value: todo.isDone,
                  onChanged: (value) {
                    setState(() {
                      TodoServices().updateTodos(index, todo);
                    });
                  },
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 20.0,
              color: Colors.amberAccent,
            );
          },
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
                    final singleTodo = TodoModel(
                      todoItem: addTodoController.text,
                      isDone: false,
                      time: DateTime.now(),
                    );
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
      TodoServices().addTodos(singleTodo);
    });
  }
}
