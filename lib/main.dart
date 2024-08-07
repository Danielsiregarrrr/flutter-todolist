import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controllers/todolist_controller.dart';
import 'package:todolist/views/todolist_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TodoController>(create: (_) => TodoController()),
      ],
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoScreen(),
      ),
    );
  }
}
