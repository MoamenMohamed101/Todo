import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/shared/components/components.dart';

class LayoutScreen extends StatelessWidget {
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      label: "Tasks",
      icon: Icon(Icons.task),
    ),
    const BottomNavigationBarItem(
      label: "Done",
      icon: Icon(Icons.done),
    ),
    const BottomNavigationBarItem(
      label: "Archive",
      icon: Icon(Icons.archive),
    ),
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>(),
      formKey = GlobalKey<FormState>();
  TextEditingController tasksController = TextEditingController(),
      timeController = TextEditingController(),
      dateController = TextEditingController();

  LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoLayoutCubit()..createDataBase(),
      child: BlocConsumer<TodoLayoutCubit, TodoLayoutStates>(
        listener: (context, state) {
          if(state is TodoLayoutInsertDataBaseSuccessState) Navigator.pop(context);
        },
        builder: (context, state) {
          TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertDataBase(
                      title: tasksController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (builder) =>
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  isObscure: false,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "tasks are empty";
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.task,
                                  radius: 10,
                                  hintText: "Enter your task",
                                  controller: tasksController,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  isObscure: false,
                                  validate: (value) {
                                    if (value!.isEmpty) return "time are empty";
                                    return null;
                                  },
                                  textInputType: TextInputType.datetime,
                                  prefixIcon: Icons.timelapse,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                    return null;
                                  },
                                  radius: 10,
                                  hintText: "Enter your task time",
                                  controller: timeController,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  isObscure: false,
                                  onTap: () {
                                    showDatePicker(
                                      initialDate: DateTime.now(),
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2030-01-01"),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value!)
                                          .toString();
                                    });
                                    return null;
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) return "date are empty";
                                    return null;
                                  },
                                  textInputType: TextInputType.datetime,
                                  prefixIcon: Icons.calendar_today,
                                  radius: 10,
                                  hintText: "Enter your date",
                                  controller: dateController,
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20,
                  )
                      .closed
                      .then((value) {
                    cubit.isBottomSheetShow = false;
                    cubit.changeIcons();
                  });
                  cubit.isBottomSheetShow = true;
                  cubit.changeIcons();
                }
              },
              child: Icon(cubit.isIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 5,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => cubit.changeIndex(index),
              items: items,
              currentIndex: cubit.currentIndex,
            ),
            body: ConditionalBuilder(
              condition: cubit.tasks.isNotEmpty,
              builder: (BuildContext context) =>
              cubit.screens[cubit.currentIndex],
              fallback: (BuildContext context) =>
              const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
    );
  }

  void updateItemDataBase() {}

  void deleteFromDataBase() {}
}