import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoApp/modules/archive_tasks/archived_tasks_screen.dart';
import 'package:todoApp/modules/done_tasks/done_tasks_screen.dart';
import 'package:todoApp/modules/new_tasks/new_tasks_screen.dart';
import 'package:todoApp/shared/components/component.dart';
import 'package:todoApp/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  var currentIndex = 0;
  bool isSheetOpened = false;
  IconData fabIcon = Icons.edit;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  late Database database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Todo App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isSheetOpened) {
            if (formKey.currentState?.validate() == true) {
              addNewTask(
                      taskTitle: titleController.text,
                      taskTime: timeController.text,
                      taskDate: dateController.text)
                  .then((value) {
                loadTasks(database).then((value) {
                  Navigator.pop(context);
                  setState(() {
                    fabIcon = Icons.edit;
                    isSheetOpened = false;
                    tasksList = value;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                    (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  controller: titleController,
                                  inputType: TextInputType.text,
                                  validator: (newValue) {
                                    if (newValue?.isEmpty == true) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  hintText: 'Task Name',
                                  prefixIcon: Icon(Icons.title),
                                ),
                                SizedBox(height: 15.0),
                                defaultTextFormField(
                                  focusInTouchMode: true,
                                  controller: timeController,
                                  inputType: TextInputType.datetime,
                                  validator: (newValue) {
                                    if (newValue?.isEmpty == true) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  hintText: 'Task Time',
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value!.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(height: 15.0),
                                defaultTextFormField(
                                  focusInTouchMode: true,
                                  controller: dateController,
                                  inputType: TextInputType.datetime,
                                  validator: (newValue) {
                                    if (newValue?.isEmpty == true) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  hintText: 'Task Date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  onTap: () {
                                    print("date picker clicked");
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2022-08-01'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 15.0)
                .closed
                .then((value) => _closeSheet());
            isSheetOpened = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 20.0,
        items: [
          BottomNavigationBarItem(
            label: 'home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Done',
            icon: Icon(Icons.check_circle_outline),
          ),
          BottomNavigationBarItem(
            label: 'Archived',
            icon: Icon(Icons.archive),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: ConditionalBuilder(
          condition: tasksList.length > 0,
          builder: (context) => screens[currentIndex],
          fallback: (context) => Center(child: CircularProgressIndicator())),
    );
  }

  void _closeSheet() {
    isSheetOpened = false;
    setState(() {
      fabIcon = Icons.edit;
    });
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('Database Created');
        db
            .execute('CREATE TABLE tasks (' +
                '_id INTEGER PRIMARY KEY,' +
                'title TEXT,' +
                'date TEXT,' +
                'time TEXT,' +
                'status TEXT)')
            .then((value) => print('Table Created'))
            .catchError((e) => print('Can\'t create tables ${e.toString()}'));
      },
      onOpen: (db) {
        loadTasks(db).then((value) {
          setState(() {
            tasksList = value;
          });
        });
        print('Database opened');
      },
    );
  }

  Future addNewTask({
    required String taskTitle,
    required String taskTime,
    required String taskDate,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$taskTitle","$taskDate","$taskTime","new")')
          .then((value) => print('$value  Inserted successfully'))
          .catchError((e) => print('Error while insert data ${e.toString()}'));
    });
  }

  Future<List<Map>> loadTasks(database) async {
    return await database.rawQuery('SELECT * FROM tasks');
  }
}
