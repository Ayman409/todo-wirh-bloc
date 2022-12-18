import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/constant.dart';
import '../../shared/componenrs.dart';
import '../../shared/cubit/app_cubit_cubit.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubitCubit, AppCubitState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ListView.separated(
          itemBuilder: (context, index) =>
              tasksTile(AppCubitCubit.get(context).tasks[index], context),
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey[300],
            );
          },
          itemCount: AppCubitCubit.get(context).tasks.length,
        );
      },
    );
  }
}
