class Todo {
  String? id;
  String? todotext;
  bool? isdone;

  Todo({required this.id, required this.todotext, required this.isdone});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todotext': todotext,
      'isdone': isdone,
    };
  }

  // Create a Todo object from a map (for JSON decoding)
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todotext: json['todotext'],
      isdone: json['isdone'],
    );
  }

  static List<Todo> todolist() {
    return [
      Todo(id: '01', todotext: 'Your first task', isdone: false),
    ];
  }
}
