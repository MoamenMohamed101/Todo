import 'package:flutter/material.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) => buildTaskItem(tasks[index]),
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 15),
        child: Container(
          height: 1,
          width: double.infinity,
          color: Colors.grey,
        ),
      ),
      itemCount: tasks.length,
    );
  }
}
