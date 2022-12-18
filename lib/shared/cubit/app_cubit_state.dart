part of 'app_cubit_cubit.dart';

@immutable
abstract class AppCubitState {}

class AppCubitInitial extends AppCubitState {}

class AppChangeBottomNavBar extends AppCubitState {}

class AppCreateDatabaseState extends AppCubitState {}

class AppGetDatabaseState extends AppCubitState {}

class AppInsertToDatabaseState extends AppCubitState {}

class AppChangeBottomSheetState extends AppCubitState {}

class AppUpdateDataState extends AppCubitState {}
