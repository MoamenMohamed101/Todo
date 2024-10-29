import 'package:flutter/material.dart';
import 'package:todo/layout/layout_cubit/todo_cubit.dart';

Widget defaultButton({
  bool isUpper = true,
  double width = double.infinity,
  double textSize = 20,
  Color color = Colors.blue,
  Color textColor = Colors.white,
  required String text,
  required VoidCallback voidCall,
}) =>
    MaterialButton(
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

Widget buildTaskItem(Map task, BuildContext context) => Padding(
      padding: const EdgeInsets.only(left: 20,top: 20,right: 20),
      child: Dismissible(
        onDismissed: (element){
          TodoLayoutCubit.get(context).deleteFromDataBase(task['id']);
        },
        key: Key(task.toString()),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Text(
                task['time'],
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    task['title'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    task['date'],
                    style: const TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => TodoLayoutCubit.get(context)
                  .updateItemDataBase(status: "done", id: task['id']),
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () => TodoLayoutCubit.get(context)
                  .updateItemDataBase(status: "archive", id: task['id']),
              icon: const Icon(Icons.archive),
            ),
          ],
        ),
      ),
    );

Widget emptyTasks() => const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 200,
            color: Colors.grey,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Empty tasks",
            style: TextStyle(
              fontSize: 50,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
