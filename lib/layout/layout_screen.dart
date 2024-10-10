import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/modules/archive_screen.dart';
import 'package:todo/modules/done_screen.dart';
import 'package:todo/modules/tasks_screen.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';

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

  List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen(),
  ];
  List<String> titles = ["Tasks Screen", "Done Screen", "Archive Screen"];

  int currentIndex = 0;
  Database? dataBase;
  var scaffoldKey = GlobalKey<ScaffoldState>(),
      formKey = GlobalKey<FormState>();
  TextEditingController tasksController = TextEditingController(),
      time = TextEditingController(),
      date = TextEditingController();
  bool isBottomSheetShow = false;
  IconData isIcon = Icons.edit;

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

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
                title: tasksController.text,
                date: date.text,
                time: time.text,
              ).then((value) {

                getDataBase(dataBase).then((onValue){
                  Navigator.pop(context);
                  setState(() {
                  });
                  isBottomSheetShow = false;
                  isIcon = Icons.edit;
                  tasks = onValue;
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
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
                                date.text = DateFormat.yMMMd()
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
                            controller: date,
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 20,
                )
                .closed
                .then((value) {
              setState(() {});
              isBottomSheetShow = false;
              isIcon = Icons.edit;
            });
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
      body: ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (BuildContext context) => screens[currentIndex],
        fallback: (BuildContext context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
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
        getDataBase(dataBase).then((onValue) {
          tasks = onValue;
        });
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

  Future<List<Map>> getDataBase(dataBase) async =>
      await dataBase!.rawQuery('SELECT * FROM tasks');

  void updateItemDataBase() {}

  void deleteFromDataBase() {}
}
