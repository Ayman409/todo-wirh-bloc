import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitial());

  // make method in the bloc that return an object from itself (the bloc)
  //to be easy when need to use it to access the cubit variables and methods
  static CounterCubit get(context) => BlocProvider.of(context);
  int counter = 0;
  void minus() {
    counter--;
    emit(CounterMinusState());
  }

  void plus() {
    counter++;
    emit(CounterPlusState());
  }
}
