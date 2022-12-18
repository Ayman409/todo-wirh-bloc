import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo2/modules/archived_tasks/archived_screen.dart';
import 'package:todo2/modules/done_tasks/done_screen.dart';
import 'package:todo2/modules/tasks/tasks_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo2/modules/widgets/input_field.dart';

import '../shared/constant.dart';
import '../shared/cubit/app_cubit_cubit.dart';

class HomeLayout extends StatelessWidget {
  var scafoldKey = GlobalKey<ScaffoldState>();
  var formdKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  // void initState() {
  //   super.initState();
  //   crateDataBase();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubitCubit()..crateDataBase(),
      child: BlocConsumer<AppCubitCubit, AppCubitState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubitCubit cubit = AppCubitCubit.get(context);
          return Scaffold(
              key: scafoldKey,
              appBar: AppBar(
                title: Text(
                  cubit.appBarTitles[cubit.currentIndex],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetIsShown) {
                    if (formdKey.currentState!.validate()) {
                      cubit.insertIntoDatabase(
                          title: timeController.text,
                          time: timeController.text,
                          date: dateController.text);
                      // insertIntoDatabase(
                      //         title: titleController.text,
                      //         time: timeController.text,
                      //         date: dateController.text)
                      //     .then(
                      //   (value) {
                      //     Navigator.pop(context);
                      //     getFromDatabase(database).then((value) {
                      //       // setState(() {
                      //       //   isBottomSheetIsShown = false;
                      //       //   fabIcon = Icons.edit;
                      //       //   tasks = value;
                      //       // });

                      //       // print(tasks);
                      //     });
                      //   },
                      // );
                    }
                  } else {
                    scafoldKey.currentState!
                        .showBottomSheet(
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
                                        widget: const Icon(Icons.title),
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
                                        widget: const Icon(
                                            Icons.watch_later_outlined),
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
                                          ).then((value) =>
                                              timeController.text = value!
                                                  .format(context)
                                                  .toString());
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AInputField(
                                        widget: const Icon(
                                            Icons.calendar_today_outlined),
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
                                                  lastDate: DateTime.parse(
                                                      '2023-01-01'))
                                              .then(
                                            (value) {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value!);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: cubit.currentIndex,
                onTap: (value) {
                  cubit.chngeIndex(value);
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
              body:
                  //  tasks.isEmpty?
                  // const Center(
                  //       child: CircularProgressIndicator(),
                  //     )
                  //   :
                  cubit.screens[cubit.currentIndex]);
        },
      ),
    );
  }
}
