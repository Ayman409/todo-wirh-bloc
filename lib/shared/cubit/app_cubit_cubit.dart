import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_screen.dart';
import '../../modules/done_tasks/done_screen.dart';
import '../../modules/tasks/tasks_screen.dart';

part 'app_cubit_state.dart';

class AppCubitCubit extends Cubit<AppCubitState> {
  AppCubitCubit() : super(AppCubitInitial());

  static AppCubitCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  late Database database;
  List<Map> tasks = [];

  List<Widget> screens = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchivedScreen(),
  ];
  List<String> appBarTitles = [
    'Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void chngeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBar());
  }

  void crateDataBase() {
    // String dbPath = await getDatabasesPath() + 'todo.db';
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE Tasks  (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT) ')
            .then((value) => print('Table Created'))
            .catchError((e) {
          print('error while creating database ${e.toString()}');
        });
        // When creating the db, create the table
      },
      onOpen: ((database) {
        getFromDatabase(database);
        print('Database Opened');
      }),
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction(
      (txn) {
        return txn
            .rawInsert(
                'INSERT INTO Tasks (title, date, time,status) VALUES("$title", "$date","$time","new")')
            .then(
          (value) {
            print('$value Inserted Successfuly');
            emit(AppInsertToDatabaseState());
            getFromDatabase(database);
          },
        ).catchError((e) {
          print(e.toString());
        });
      },
    );
  }

  void updateData({required String status, required int id}) async {
    database.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
        ['${status}', '$id']).then((value) {
      emit(AppUpdateDataState());
    });
  }

  void getFromDatabase(database) {
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      tasks = value;
      print(tasks);
      emit(AppGetDatabaseState());
    });
    ;
  }

  bool isBottomSheetIsShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetIsShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
}
