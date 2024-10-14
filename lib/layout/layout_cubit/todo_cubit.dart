import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/modules/archive_screen.dart';
import 'package:todo/modules/done_screen.dart';
import 'package:todo/modules/tasks_screen.dart';

class TodoLayoutCubit extends Cubit<TodoLayoutStates>{
  TodoLayoutCubit() : super (TodoLayoutInitialState());

  static TodoLayoutCubit get(context)=> BlocProvider.of(context);

  List<Map> tasks = [];
  int currentIndex = 0;
  bool isBottomSheetShow = false;
  IconData isIcon = Icons.edit;

  late List<Widget> screens = [
    TasksScreen(tasks),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ["Tasks Screen", "Done Screen", "Archive Screen"];

  void changeIndex(int index)
  {
    currentIndex = index;
    emit(TodoLayoutChangeIndexState());
  }

  void changeIcons()
  {
    isBottomSheetShow ? isIcon = Icons.add : isIcon = Icons.edit;
    emit(TodoLayoutChangeIconState());
  }
}