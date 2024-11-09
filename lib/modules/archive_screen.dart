import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/shared/components/components.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoLayoutCubit, TodoLayoutStates>(
      builder: (BuildContext context, state) {
        TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
        return cubit.archiveTasks.isEmpty
            ? emptyTasks()
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return buildTaskItem(cubit.archiveTasks[index], context, 2);
                },
                itemCount: cubit.archiveTasks.length,
              );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
