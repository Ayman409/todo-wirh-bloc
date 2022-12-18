import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:todo2/shared/cubit/app_cubit_cubit.dart';

Widget tasksTile(Map model, context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        IconButton(
            onPressed: () {
              AppCubitCubit.get(context)
                  .updateData(status: 'done', id: model['id']);
            },
            icon: const Icon(
              Icons.check_box_outlined,
              color: Colors.greenAccent,
            )),
        IconButton(
            onPressed: () {
              AppCubitCubit.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: const Icon(
              Icons.archive_outlined,
              color: Colors.grey,
            ))
      ],
    ),
  );
}
