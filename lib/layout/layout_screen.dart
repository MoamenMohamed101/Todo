import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final scaffoldKey = GlobalKey<ScaffoldState>(),
      formKey = GlobalKey<FormState>();
  final TextEditingController tasksController = TextEditingController(),
      timeController = TextEditingController(),
      dateController = TextEditingController(),
      titleController = TextEditingController();

  LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoLayoutCubit, TodoLayoutStates>(
      listener: (context, state) {
        if (state is TodoLayoutInsertDataBaseSuccessState ||
            state is TodoLayoutUpdateDataBaseSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        TodoLayoutCubit cubit = TodoLayoutCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: Theme.of(context).textTheme.displaySmall,
            ),
            // actions: [
            //   StreamBuilder<DateTime>(
            //     stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Padding(
            //           padding: const EdgeInsets.only(right: 10),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.end,
            //             children: [
            //               Text(
            //                 DateFormat.Hms().format(snapshot.data!),
            //                 style: Theme.of(context).textTheme.displaySmall!.copyWith(
            //                   fontSize: 20,
            //                 ),
            //               ),
            //               Text(
            //                 DateFormat.yMMMMd().format(snapshot.data!),
            //                 style: Theme.of(context).textTheme.displaySmall!.copyWith(
            //                   fontSize: 20,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       } else {
            //         return const SizedBox();
            //       }
            //     },
            //   ),
            // ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
                if (formKey.currentState!.validate()) {
                  cubit
                      .insertDataBase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                    task: tasksController.text,
                  )
                      .then((onValue) {
                    showToast(
                        message: "Task added successfully",
                        state: ToastStates.insert);
                  });
                }
              } else {
                scaffoldKey.currentState!
                    .showBottomSheet(
                      (builder) => StatefulBuilder(
                        builder: (BuildContext context,
                                void Function(void Function()) setState) =>
                            Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "title is empty";
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.title,
                                  radius: 10,
                                  hintText: "Enter the title",
                                  controller: titleController,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                defaultTextFormField(
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "task is empty";
                                    }
                                    return null;
                                  },
                                  textInputType: TextInputType.text,
                                  prefixIcon: Icons.task,
                                  radius: 10,
                                  hintText: "Enter your task",
                                  controller: tasksController,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                defaultTextFormField(
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
                                SizedBox(
                                  height: 15.h,
                                ),
                                defaultTextFormField(
                                  onTap: () {
                                    showDatePicker(
                                      initialDate: DateTime.now(),
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2030-01-01"),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMMd()
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
                                  hintText: "Enter your task date",
                                  controller: dateController,
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            cubit.myIndex = index;
                                          });
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              cubit.getIndex(index: index),
                                          radius: 20,
                                          child: cubit.myIndex == index
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                      width: 20.h,
                                    ),
                                    itemCount: 6,
                                  ),
                                )
                              ],
                            ),
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
            condition: state is! TodoLayoutGetDataBaseLoadingState,
            builder: (BuildContext context) {
              return cubit.screens[cubit.currentIndex];
            },
            fallback: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
