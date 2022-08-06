import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoApp/shared/cubit/states.dart';

import '../../modules/archive_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  var currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<Map> tasksList = [];
  List<String> titles = ["Home", "Done", "Archived"];
  late Database database;
  static AppCubit get(context) => BlocProvider.of(context);
  bool isSheetOpened = false;
  IconData fabIcon = Icons.edit;

  void updateBottomBarIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  void createDatabase() {
    openDatabase(
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
          tasksList = value;
          emit(AppGetDatabaseState());
        });
        print('Database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  addNewTask({
    required String taskTitle,
    required String taskTime,
    required String taskDate,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$taskTitle","$taskDate","$taskTime","new")')
          .then((value) {
        emit(AppInsertDatabaseState());
        print('$value  Inserted successfully');

        loadTasks(database).then((value) {
          tasksList = value;
          emit(AppGetDatabaseState());
        });
      }).catchError((e) => print('Error while insert data ${e.toString()}'));
    });
  }

  Future<List<Map>> loadTasks(database) async {
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  void changeBottomSheetState(bool isShown, IconData icon) {
    isSheetOpened = isShown;
    fabIcon = icon;
    emit(AppChangeBottomNavBarState());
  }
}
