import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../model/todomodel.dart';

class Todoitem extends StatefulWidget {
  final Todo todo;
  final ontodochanged;
  final ondeleteitem;

  const Todoitem(
      {required this.todo,
      required this.ontodochanged,
      required this.ondeleteitem,
      super.key});

  @override
  State<Todoitem> createState() => _TodoitemState();
}

class _TodoitemState extends State<Todoitem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: ListTile(
        onTap: () {
          widget.ontodochanged(widget.todo);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          widget.todo.isdone! ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdblue,
        ),
        title: Text(
          widget.todo.todotext!,
          style: TextStyle(
              fontSize: 17,
              color: tdblack,
              decoration:
                  widget.todo.isdone! ? TextDecoration.lineThrough : null),
        ),
        trailing: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              color: tdred, borderRadius: BorderRadius.circular(7)),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              widget.ondeleteitem(widget.todo.id!);
            },
            icon: const Icon(Icons.delete),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
