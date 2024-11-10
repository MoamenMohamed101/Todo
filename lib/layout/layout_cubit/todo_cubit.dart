import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/layout_cubit/todo_states.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/modules/archive_screen.dart';
import 'package:todo/modules/done_screen.dart';
import 'package:todo/modules/tasks_screen.dart';
import 'package:todo/shared/network/local/local_notification_service.dart';

class TodoLayoutCubit extends Cubit<TodoLayoutStates> {
  TodoLayoutCubit() : super(TodoLayoutInitialState());

  static TodoLayoutCubit get(context) => BlocProvider.of(context);

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  int currentIndex = 0;
  bool isBottomSheetShow = false;
  IconData isIcon = Icons.edit;
  Database? dataBase;
  int myIndex = 0;

  DateTime currentDate = DateTime.now();

  final TextEditingController tasksController = TextEditingController(),
      timeController = TextEditingController(),
      dateController = TextEditingController(),
      titleController = TextEditingController();

  late TimeOfDay scheduledTime;
  late DateTime scheduledDate;

  late List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ["Tasks Screen", "Done Screen", "Archive Screen"];

  void changeIndex(int index) {
    currentIndex = index;
    emit(TodoLayoutChangeIndexState());
  }

  void changeColorIndex(int index) {
    myIndex = index;
    emit(TodoLayoutChangeColorIndexState());
  }

  void changeIcons() {
    isBottomSheetShow ? isIcon = Icons.add : isIcon = Icons.edit;
    emit(TodoLayoutChangeIconState());
  }

  Color getIndex({int? index}) {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.pink;
      case 5:
        return Colors.cyan;
      default:
        return Colors.blue;
    }
  }

  void getSelectedDate(DateTime date) {
    currentDate = date;
    emit(TodoLayoutChangeDateSuccessState());
    getDataBase(dataBase);
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
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, task TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          debugPrint("tables created");
        }).catchError((error) {
          debugPrint("error when creating tables: ${error.toString()}");
        });
      },
      onOpen: (dataBase) {
        getDataBase(dataBase);
        debugPrint("database opened");
      },
    ).then((onValue) {
      dataBase = onValue;
      emit(TodoLayoutCreateDataBaseState());
    });
  }

  Future insertDataBase({
    required String title,
    required String task,
    required String date,
    required String time,
  }) async {
    return await dataBase!.transaction((action) => action
            .rawInsert(
                'INSERT INTO tasks (title,task,date,time,status) VALUES("$title","$task","$date","$time","new")')
            .then((value) {

          debugPrint("$value inserted successfully");
          getDataBase(dataBase);
          LocalNotificationService.scheduledNotification(
              currentDate: scheduledDate,
              scheduledTime: scheduledTime,
              taskModel: TaskModel(
                id: value,
                title: titleController.text,
                description: tasksController.text,
              )
          );
          emit(TodoLayoutInsertDataBaseSuccessState());
        }).catchError((error) {
          debugPrint("error will inserting $error");
          emit(TodoLayoutInsertDataBaseErrorState());
        }));
  }

  void getDataBase(dataBase) {
    emit(TodoLayoutGetDataBaseLoadingState());
    newTasks.clear();
    doneTasks.clear();
    archiveTasks.clear();
    dataBase!.rawQuery('SELECT * FROM tasks').then((onValue) {
      onValue.forEach((element) {
        if (element['status'] == 'new' && element['date'] == DateFormat.yMMMMd().format(currentDate)) {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive'){
          archiveTasks.add(element);
        }
      });
      emit(TodoLayoutGetDataBaseSuccessState());
    });
  }

  void updateItemDataBase({required String status, required int id}) async {
    dataBase!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((onValue) {
      getDataBase(dataBase);
      emit(TodoLayoutUpdateDataBaseSuccessState());
    });
  }

  void deleteFromDataBase(int task) {
    dataBase!.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [task],
    ).then((onValue) {
      getDataBase(dataBase);
      emit(TodoLayoutDeleteDataBaseSuccessState());
    });
  }
}
