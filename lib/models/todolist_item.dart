class Todo {
  final String id; // ID item
  String title; // Judul item
  bool isCompleted; // Status item selesai atau belum

  // Konstruktor class Todo
  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // Membuat objek Todo dari JSON
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['status'],
    );
  }

  // Mengubah objek Todo menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'status': isCompleted,
    };
  }
}
