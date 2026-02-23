import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: .center,
      child: ListView(
        children: List.generate(
          100,
          (index) => Container(
            height: 50,
            alignment: Alignment.center,
            child: Text("Task $index"),
          ),
        ),
      ),
    );
  }
}
