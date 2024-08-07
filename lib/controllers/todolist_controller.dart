import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/models/todolist_item.dart';

class TodoController {
  final String apiUrl = 'https://66747d0375872d0e0a969de6.mockapi.io/todos';

  // Ambil daftar todos dari API
  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil daftar tugas');
    }
  }

  // Tambah todo baru ke API
  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambah tugas');
    }
  }

  // Update todo di API
  Future<void> updateTodo(Todo todo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${todo.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal memperbarui tugas');
    }
  }

  // Hapus todo dari API
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Gagal menghapus tugas');
    }
  }
}
