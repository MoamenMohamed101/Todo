import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/shared/components/components.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen( {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoLayoutCubit,TodoLayoutStates>(
      builder: (BuildContext context, state) {
        TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return buildTaskItem(cubit.tasks[index]);
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 15),
            child: Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
          ),
          itemCount: cubit.tasks.length,
        );
      },
      listener: (BuildContext context, Object? state) {  },
    );
  }
}