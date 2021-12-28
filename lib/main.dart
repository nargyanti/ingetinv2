import 'package:flutter/material.dart';
import 'package:ingetin/providers/AuthProvider.dart';
import 'package:ingetin/providers/CategoryProvider.dart';
import 'package:ingetin/providers/TodoProvider.dart';
import 'package:ingetin/screens/categories.dart';
import 'package:ingetin/screens/home.dart';
import 'package:ingetin/screens/login.dart';
import 'package:ingetin/screens/register.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return MultiProvider(
              providers: [
                ChangeNotifierProvider<CategoryProvider>(
                    create: (context) => CategoryProvider(authProvider)),
                ChangeNotifierProvider<TodoProvider>(
                    create: (context) => TodoProvider(authProvider))
              ],
              child: MaterialApp(title: 'Welcome to Flutter', routes: {
                '/': (context) {
                  final authProvider = Provider.of<AuthProvider>(context);
                  if (authProvider.isAuthenticated) {
                    return Home();
                  } else {
                    return Login();
                  }
                },
                '/login': (context) => Login(),
                '/register': (context) => Register(),
                '/home': (context) => Home(),
                '/categories': (context) => Categories(),
              }));
        }));
  }
}
