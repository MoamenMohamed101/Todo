import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';
import 'package:todo/shared/styles/app_assets.dart';
import 'package:todo/shared/styles/colors.dart';
import 'package:todo/shared/styles/strings.dart';

Widget defaultButton({
  bool isUpper = true,
  double width = double.infinity,
  double textSize = 20,
  Color color = Colors.blue,
  Color textColor = Colors.white,
  AlignmentGeometry alignment = Alignment.center,
  required String text,
  required VoidCallback voidCall,
}) =>
    Align(
      alignment: alignment,
      child: MaterialButton(
        clipBehavior: Clip.antiAlias,
        minWidth: width,
        onPressed: voidCall,
        color: color,
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
          ),
        ),
      ),
    );

Widget defaultTextFormField({
  bool isSuffix = true,
  bool isObscure = false,
  Function? onField,
  Function? onChanged,
  VoidCallback? iconButtonFunction,
  required String? Function(String?)? validate,
  String? Function()? onTap,
  required TextEditingController controller,
  required TextInputType textInputType,
  required IconData prefixIcon,
  IconData? suffixIcon,
  required double radius,
  required String hintText,
}) =>
    TextFormField(
      onFieldSubmitted: (value) => onField,
      onChanged: (value) => onChanged,
      onTap: onTap,
      validator: validate,
      controller: controller,
      obscureText: isObscure,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isSuffix
            ? IconButton(
                onPressed: iconButtonFunction,
                icon: Icon(suffixIcon),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
      ),
    );

Widget buildTaskItem(Map task, BuildContext context, index) => InkWell(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 300,
              color: AppColors.deepGrey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultButton(
                      color: AppColors.primaryColorOfLight,
                      text: "Task Completed",
                      voidCall: () {
                        TodoLayoutCubit.get(context).updateItemDataBase(
                          status: 'done',
                          id: task['id'],
                        );
                        showToast(message: "Task completed successfully", state: ToastStates.done);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultButton(
                      color: AppColors.primaryColorOfLight,
                      text: "Task Archive",
                      voidCall: () {
                        TodoLayoutCubit.get(context).updateItemDataBase(
                          status: 'archive',
                          id: task['id'],
                        );
                        showToast(message: "Task archived successfully", state: ToastStates.archived);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultButton(
                      color: Colors.red,
                      text: "Delete Task",
                      voidCall: () {
                        TodoLayoutCubit.get(context).deleteFromDataBase(
                          task['id'],
                        );
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    defaultButton(
                      color: AppColors.primaryColorOfLight,
                      text: "Cancel",
                      voidCall: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Dismissible(
        key: Key(task.toString()),
        onDismissed: (element) {
          TodoLayoutCubit.get(context).deleteFromDataBase(task['id']);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5.0,
            color: TodoLayoutCubit.get(context).getIndex(index: index),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task["title"],
                        style:
                            Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Colors.white,
                                ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer_sharp, color: Colors.white),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            task['time'],
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            task['date'],
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        task["task"],
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 100,
                    width: 1,
                    color: Colors.white,
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      task["status"] == "done"
                          ? AppStrings.done
                          : task["status"] == "archive"
                              ? AppStrings.archived
                              : AppStrings.todo,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: Colors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

Widget emptyTasks() => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(AppAssets.noTasks),
          ),
          Text(
            AppStrings.noTaskTitle,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          Text(
            AppStrings.noTaskSubTitle,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );

void navigateAndFinish({context, widget}) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (Route<dynamic> route) => false);

void navigateTo({context, widget}) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Widget commonTextButton({
  required String text,
  required TextStyle? textStyle,
  required Function()? function,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text,
        style: textStyle,
      ),
    );

void showToast({required String message, required ToastStates state}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: getColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { insert, done, archived }

Color getColor(ToastStates toastStates) {
  Color color;
  switch (toastStates) {
    case ToastStates.insert:
      color = Colors.blue;
      break;
    case ToastStates.done:
      color = Colors.green;
      break;
    case ToastStates.archived:
      color = Colors.grey;
      break;
  }
  return color;
}
