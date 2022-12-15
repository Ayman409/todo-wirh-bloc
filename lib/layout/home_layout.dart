import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo2/modules/archived_tasks/archived_screen.dart';
import 'package:todo2/modules/done_tasks/done_screen.dart';
import 'package:todo2/modules/tasks/tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo2/modules/widgets/input_field.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
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
  Database? database;
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formdKey = GlobalKey<FormState>();
  bool isBottomSheetIsShown = false;
  IconData fabIcon = Icons.edit;
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    crateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(title: Text(appBarTitles[currentIndex])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetIsShown) {
            if (formdKey.currentState!.validate()) {
              insertIntoDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text)
                  .then(
                (value) {
                  Navigator.pop(context);
                  isBottomSheetIsShown = false;
                  setState(() {
                    fabIcon = Icons.edit;
                  });
                },
              );
            }
          } else {
            scafoldKey.currentState!.showBottomSheet(
              elevation: 20,
              (context) => Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Form(
                      key: formdKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AInputField(
                            widget: Icon(Icons.title),
                            title: 'Task Title',
                            hint: 'Add task here',
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Title must not be empty';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AInputField(
                            widget: Icon(Icons.watch_later_outlined),
                            title: 'Task Time',
                            hint: 'Add task time',
                            type: TextInputType.datetime,
                            controller: timeController,
                            // isClickable: false,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Time must not be empty';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) => timeController.text =
                                  value!.format(context).toString());
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AInputField(
                            widget: Icon(Icons.calendar_today_outlined),
                            title: 'Date',
                            hint: 'Add date',
                            type: TextInputType.datetime,
                            controller: timeController,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              } else {
                                return null;
                              }
                            },
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-01-01'))
                                  .then(
                                (value) {
                                  dateController.text =
                                      DateFormat.yMMMd().format(value!);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            );
            isBottomSheetIsShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'Done'),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: 'Archived'),
        ],
      ),
      body: screens[currentIndex],
    );
  }

  void crateDataBase() async {
    // String dbPath = await getDatabasesPath() + 'todo.db';
    database = await openDatabase(
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
        print('Database Opened');
      }),
    );
  }

  Future insertIntoDatabase(
      {required String title,
      required String time,
      required String date}) async {
    return await database!.transaction(
      (txn) {
        return txn
            .rawInsert(
                'INSERT INTO Tasks (title, date, time,status) VALUES("$title", "$date","$time","new")')
            .then((value) => print('$value Inserted Successfuly'))
            .catchError((e) {
          print(e.toString());
        });
      },
    );
  }
}
