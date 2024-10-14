import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/modules/archive_screen.dart';
import 'package:todo/modules/done_screen.dart';
import 'package:todo/modules/tasks_screen.dart';

class TodoLayoutCubit extends Cubit<TodoLayoutStates> {
  TodoLayoutCubit() : super(TodoLayoutInitialState());

  static TodoLayoutCubit get(context) => BlocProvider.of(context);

  List<Map> tasks = [];
  int currentIndex = 0;
  bool isBottomSheetShow = false;
  IconData isIcon = Icons.edit;
  Database? dataBase;

  late List<Widget> screens = [
    TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ["Tasks Screen", "Done Screen", "Archive Screen"];

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoLayoutChangeIndexState());
  }

  void changeIcons() {
    isBottomSheetShow ? isIcon = Icons.add : isIcon = Icons.edit;
    emit(TodoLayoutChangeIconState());
  }

  // void changeIcons(bool isShow,IconData icon)
  // {
  //   isBottomSheetShow = isShow;
  //   isIcon = icon;
  // emit(TodoLayoutChangeIconState());
  // }

  void createDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (dataBase, version) {
        debugPrint("database created");
        dataBase
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          debugPrint("tables created");
        }).catchError((error) {
          debugPrint("error when creating tables: ${error.toString()}");
        });
      },
      onOpen: (dataBase) {
        getDataBase(dataBase).then((onValue) {
          tasks = onValue;
          emit(TodoLayoutGetDataBaseSuccessState());
        });
        debugPrint("database opened");
      },
    ).then((onValue) {
      dataBase = onValue;
      emit(TodoLayoutCreateDataBaseState());
    });
  }

  Future insertDataBase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await dataBase!.transaction((action) => action
            .rawInsert(
                'INSERT INTO tasks (title,date,time,status) VALUES("$title","$date","$time","new")')
            .then((value) {
          debugPrint("$value inserted successfully");
          getDataBase(dataBase).then((onValue){
            tasks = onValue;
            emit(TodoLayoutGetDataBaseSuccessState());
          });
          emit(TodoLayoutInsertDataBaseSuccessState());
        }).catchError((error) {
          debugPrint("error will inserting $error");
          emit(TodoLayoutInsertDataBaseErrorState());
        }));
  }

  Future<List<Map>> getDataBase(dataBase) async =>
      await dataBase!.rawQuery('SELECT * FROM tasks');
}
