import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ingetin/models/category.dart';
import 'package:ingetin/models/todo.dart';

class ApiService {
  late String token;

  ApiService(String token) {
    this.token = token;
  }

  final String baseUrl = 'https://ingetin.ceban-app.com/api';

  Future<List<Category>> fetchCategories() async {
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'categories'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    List categories = jsonDecode(response.body);

    return categories.map((category) => Category.fromJson(category)).toList();
  }

  Future<Category> addCategory(String name) async {
    String uri = baseUrl + 'categories';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({'name': name}));

    if (response.statusCode != 201) {
      throw Exception('Error happened on create');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<Category> updateCategory(Category category) async {
    String uri = baseUrl + 'categories/' + category.id.toString();

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({'name': category.name}));

    if (response.statusCode != 200) {
      throw Exception('Error happened on update');
    }

    return Category.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteCategory(id) async {
    String uri = baseUrl + 'categories/' + id.toString();
    http.Response response = await http.delete(
      Uri.parse(uri),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error happened on delete');
    }
  }

  Future<List<Todo>> fetchTodos() async {
    http.Response response = await http.get(
      Uri.parse(baseUrl + 'todos'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    List todos = jsonDecode(response.body);

    return todos.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<Todo> addTodo(String name, String description, String dueDate, String dueTime, int categoryId) async {
    String uri = baseUrl + 'todos';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'name': name,          
          'description': description,
          'due_date': dueDate,
          'due_time': dueTime,
          'category_id': categoryId
        }));

    if (response.statusCode != 201) {
      throw Exception('Error happened on create');
    }

    return Todo.fromJson(jsonDecode(response.body));
  }

  Future<Todo> updateTodo(Todo todo) async {
    String uri = baseUrl + 'todos/' + todo.id.toString();

    http.Response response = await http.put(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode({
          'name': todo.name,          
          'description': todo.description,
          'due_date': todo.dueDate,
          'due_time': todo.dueTime,
          'category_id': todo.categoryId
        }));

    if (response.statusCode != 200) {
      throw Exception('Error happened on update');
    }

    return Todo.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteTodo(id) async {
    String uri = baseUrl + 'todos/' + id.toString();
    http.Response response = await http.delete(
      Uri.parse(uri),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error happened on delete');
    }
  }

  Future<String> register(String name, String email, String password,
      String passwordConfirm) async {
    String uri = baseUrl + 'register';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirm,          
        }));

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }

    // return token
    return response.body;
  }

  Future<String> login(String email, String password) async {
    String uri = baseUrl + 'login';

    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,          
        }));

    if (response.statusCode == 422) {
      Map<String, dynamic> body = jsonDecode(response.body);
      Map<String, dynamic> errors = body['errors'];
      String errorMessage = '';
      errors.forEach((key, value) {
        value.forEach((element) {
          errorMessage += element + '\n';
        });
      });
      throw Exception(errorMessage);
    }

    // return token
    return response.body;
  }
}
