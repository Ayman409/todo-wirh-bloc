part of 'counter_cubit.dart';

@immutable
abstract class CounterState {}

class CounterInitial extends CounterState {}

class CounterMinusState extends CounterState {}

class CounterPlusState extends CounterState {}
