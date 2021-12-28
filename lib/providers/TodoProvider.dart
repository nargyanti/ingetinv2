// ignore_for_file: prefer_initializing_formals, file_names

import 'package:flutter/material.dart';
import 'package:ingetin/models/todo.dart';
import 'package:ingetin/providers/AuthProvider.dart';
import 'package:ingetin/services/api.dart';

class TodoProvider extends ChangeNotifier {
  List<dynamic> todos = [];
  late ApiService apiService;
  late AuthProvider authProvider;

  TodoProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.apiService = ApiService(authProvider.token);

    init();
  }

  Future init() async {
    todos = await apiService.fetchTodos();
    notifyListeners();
  }

  Future<void> addTodo(String name, String description, String dueDate, String dueTime, int categoryId) async {
    try {
      Todo addedTodo = await apiService.addTodo(name, description, dueDate, dueTime, categoryId);
      todos.add(addedTodo);

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      Todo updatedTodo = await apiService.updateTodo(todo);
      int index = todos.indexOf(todo);
      todos[index] = updatedTodo;

      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    try {
      await apiService.deleteTodo(todo.id);

      todos.remove(todo);
      notifyListeners();
    } catch (Exception) {
      await authProvider.logOut();
    }
  }
}