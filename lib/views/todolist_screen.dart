import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/controllers/todolist_controller.dart';
import 'package:todolist/models/todolist_item.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TodoController _todoController; // Kontroller untuk mengelola todo
  List<Todo> _todos = []; // Daftar todo

  @override
  void initState() {
    super.initState();
    _todoController = Provider.of<TodoController>(context,
        listen: false); // Inisialisasi kontroller
    _loadTodos(); // Memuat daftar todo
  }

  // Memuat daftar todo dari API
  Future<void> _loadTodos() async {
    try {
      List<Todo> todos = await _todoController.getTodos();
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      print(e);
    }
  }

  // Menambahkan todo baru
  Future<void> _addTodo() async {
    TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter todo title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                String title = _controller.text.trim();
                if (title.isNotEmpty) {
                  Todo newTodo = Todo(
                    id: '', // ID akan diatur oleh API
                    title: title,
                  );
                  await _todoController.addTodo(newTodo);
                  _loadTodos(); // Memuat ulang daftar todo
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Mengedit judul todo
  Future<void> _editTodoItem(Todo todo) async {
    TextEditingController _controller = TextEditingController();
    _controller.text = todo.title;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter new title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String newTitle = _controller.text.trim();
                if (newTitle.isNotEmpty) {
                  todo.title = newTitle;
                  await _todoController.updateTodo(todo);
                  _loadTodos(); // Memuat ulang daftar todo
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Mengubah status todo (selesai/belum)
  Future<void> _updateTodoStatus(Todo todo) async {
    todo.isCompleted = !todo.isCompleted;
    await _todoController.updateTodo(todo);
    _loadTodos(); // Memuat ulang daftar todo
  }

  // Menghapus todo
  Future<void> _deleteTodo(String id) async {
    await _todoController.deleteTodo(id);
    _loadTodos(); // Memuat ulang daftar todo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (bool? value) {
                _updateTodoStatus(todo);
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteTodo(todo.id);
              },
            ),
            onTap: () {
              _editTodoItem(todo);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
