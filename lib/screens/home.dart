import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../constants/colors.dart';
import '../widgets/todoitem.dart';
import '../model/todomodel.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TodoService {
  // Save Todo list to Shared Preferences
  Future<void> saveTodos(List<Todo> todos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todoStrings =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    prefs.setStringList('todos', todoStrings);
  }

  // Load Todo list from Shared Preferences
  Future<List<Todo>> loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todoStrings = prefs.getStringList('todos');
    if (todoStrings != null) {
      return todoStrings.map((str) => Todo.fromJson(jsonDecode(str))).toList();
    } else {
      return [];
    }
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final todosList = Todo.todolist();
final todocontroller = TextEditingController();
List<Todo> foundtodo = [];
//final FocusNode focusfield = FocusNode();

class _HomeState extends State<Home> {
  TodoService todoService = TodoService();

  @override
  void initState() {
    super.initState();
    loadTodos(); // Load the todos when the app starts
  }

  void loadTodos() async {
    List<Todo> loadedTodos = await todoService.loadTodos();
    setState(() {
      foundtodo = loadedTodos;
    });
  }

  void changetodo(Todo todo) {
    setState(() {
      todo.isdone = !todo.isdone!;
    });
  }

  void deletetodo(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      foundtodo.removeWhere((item) => item.id == id);
    });
    todoService.saveTodos(todosList); // Save the updated todosList
  }

  void addtodo(String title) {
    setState(() {
      foundtodo.add(Todo(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          todotext: title,
          isdone: false));
      todocontroller.clear();
    });
    todoService.saveTodos(todosList);
  }

  void runfilter(String words) {
    // ignore: unused_local_variable
    List<Todo> results = [];
    if (words.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todotext!.toLowerCase().contains(words.toLowerCase()))
          .toList();
    }

    setState(() {
      foundtodo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            color: tdbg,
            child: Column(
              children: [
                searchbox(runfilter),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          'All ToDos',
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w500,
                              color: tdblacker),
                        ),
                      ),
                      for (Todo item in foundtodo)
                        Todoitem(
                          todo: item,
                          ontodochanged: changetodo,
                          ondeleteitem: deletetodo,
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                    height: 60,
                    margin:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    padding: const EdgeInsets.only(top: 7, left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 0),
                            blurRadius: 5,
                            spreadRadius: 0),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                          hintText: "Add new todo", border: InputBorder.none),
                      controller: todocontroller,
                      // focusNode: focusfield,
                      // onTap: () => {focusfield.requestFocus()},
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20, right: 20),
                child: ElevatedButton(
                  onPressed: () {
                    addtodo(todocontroller.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdblue,
                    foregroundColor: Colors.white,
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

Widget searchbox(runfilter) {
  return Container(
    padding: const EdgeInsets.only(left: 15, right: 15),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), color: Colors.white),
    child: TextField(
        onChanged: (value) => runfilter(value),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdblack, size: 20),
            border: InputBorder.none,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 25, maxHeight: 20),
            hintText: 'Search',
            hintStyle: TextStyle(color: tdblack))),
  );
}

AppBar buildAppBar() {
  return AppBar(
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Icon(Icons.menu, color: tdblack, size: 30),
      // ignore: sized_box_for_whitespace
      Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ClipOval(
            child: Image.asset('assets/images/mepic.jpg'),
          ))
    ]),
    backgroundColor: tdbg,
  );
}
