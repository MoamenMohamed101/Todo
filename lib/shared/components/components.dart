import 'package:flutter/material.dart';

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
  bool isObscure = true,
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

Widget buildTaskItem(Map task) => Padding(
      padding: const EdgeInsets.all(20.0),
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
          Column(
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
          )
        ],
      ),
    );
