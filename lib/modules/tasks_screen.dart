import 'package:date_picker_timeline/date_picker_timeline.dart';

//import 'package:date_picker_timeline/extra/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/styles/colors.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoLayoutCubit, TodoLayoutStates>(
      builder: (BuildContext context, state) {
        TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
        return Column(
          children: [
            SizedBox(
              height: 90,
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                selectionColor: AppColors.primaryColorOfLight,
                selectedTextColor: Colors.white,
              ),
            ),
            cubit.newTasks.isEmpty
                ? emptyTasks()
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return buildTaskItem(cubit.newTasks[index], context);
                    },
                    itemCount: cubit.newTasks.length,
                  ),
          ],
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
