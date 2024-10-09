import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archive_screen.dart';
import 'package:todo/modules/done_screen.dart';
import 'package:todo/modules/tasks_screen.dart';
import 'package:todo/shared/components/components.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
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
  final List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ["Tasks Screen", "Done Screen", "Archive Screen"];
  int currentIndex = 0;
  Database? dataBase;
  var scaffoldKey = GlobalKey<ScaffoldState>(),formKey = GlobalKey<FormState>();
  TextEditingController tasks = TextEditingController(),time = TextEditingController(),date = TextEditingController();
  bool isBottomSheetShow = false;
  IconData isIcon = Icons.edit;

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  // My name is moamen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShow) {
            if (formKey.currentState!.validate()) {
              insertDataBase(
                title: tasks.text,
                date: date.text,
                time: time.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShow = false;
                isIcon = Icons.edit;
              });
            }
          } else {
            scaffoldKey.currentState!.showBottomSheet(
              (builder) => Container(
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
                          if (value!.isEmpty) return "tasks are empty";
                          return null;
                        },
                        textInputType: TextInputType.text,
                        prefixIcon: Icons.task,
                        radius: 10,
                        hintText: "Enter your task",
                        controller: tasks,
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
                            time.text = value!.format(context).toString();
                          });
                          return null;
                        },
                        radius: 10,
                        hintText: "Enter your task time",
                        controller: time,
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
                            date.text =
                                DateFormat.yMMMd().format(value!).toString();
                          });
                        },
                        validate: (value) {
                          if (value!.isEmpty) return "date are empty";
                          return null;
                        },
                        textInputType: TextInputType.datetime,
                        prefixIcon: Icons.calendar_today,
                        radius: 10,
                        hintText: "Enter your date",
                        controller: date,
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 20,
            );
            isBottomSheetShow = true;
            isIcon = Icons.add;
          }
          setState(() {});
        },
        child: Icon(isIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: items,
        currentIndex: currentIndex,
      ),
      body: screens[currentIndex],
    );
  }

  void createDataBase() async {
    dataBase = await openDatabase(
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
        debugPrint("database opened");
      },
    );
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
        }).catchError((error) {
          debugPrint("error will inserting $error");
        }));
  }

  void getDataBase() {}

  void updateItemDataBase() {}

  void deleteFromDataBase() {}
}