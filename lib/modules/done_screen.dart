import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/shared/components/components.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoLayoutCubit, TodoLayoutStates>(
      builder: (BuildContext context, state) {
        TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
        return cubit.doneTasks.isEmpty ? emptyTasks() : ListView.builder(
          shrinkWrap: true,
           physics: const BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return buildTaskItem(cubit.doneTasks[index], context);
          },
          itemCount: cubit.doneTasks.length,
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
