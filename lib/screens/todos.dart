import 'package:flutter/material.dart';
import 'package:ingetin/models/todo.dart';
import 'package:ingetin/widgets/TodoAdd.dart';
import 'package:ingetin/widgets/TodoEdit.dart';
import 'package:provider/provider.dart';
import 'package:ingetin/providers/TodoProvider.dart';

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    List todos = provider.todos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          Todo todo = todos[index];
          return Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListTile(        
              title: Text(todo.name),
              subtitle: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(todo.description),
                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(todo.dueDate),
                      Text(todo.dueTime),
                    ],
                  )
                ])
              ]),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return TodoEdit(todo, provider.updateTodo);
                        });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text("Are you sure you want to delete?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                  child: Text("Delete"),
                                  onPressed: () => deleteTodo(
                                      provider.deleteTodo, todo, context)),
                            ],
                          );
                        });
                  },
                )
              ]),
              isThreeLine: true,
          ),),
          );
        },
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return TodoAdd(provider.addTodo);
                });
          },
          child: Icon(Icons.add)),
    );
  }

  Future deleteTodo(Function callback, Todo todo, BuildContext context) async {
    await callback(todo);
    Navigator.pop(context);
  }
}
