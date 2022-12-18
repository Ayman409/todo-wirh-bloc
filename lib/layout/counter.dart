import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/counter_cubit.dart';

class CounterScreen extends StatelessWidget {
  // int counter = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).plus();
                        // ignore: avoid_print
                        print(CounterCubit.get(context).counter);
                      },
                      child: const Text('Add'),
                    ),
                    Text('${CounterCubit.get(context).counter}'),
                    TextButton(
                      onPressed: () {
                        CounterCubit.get(context).minus();
                        print(CounterCubit.get(context).counter);
                      },
                      child: const Text('Minus'),
                    )
                  ]),
            ),
          );
        },
      ),
    );
  }
}
