part of 'clock_in_bloc.dart';

sealed class ClockInState extends Equatable {
  const ClockInState();
  
  @override
  List<Object> get props => [];
}

final class ClockInInitial extends ClockInState {}
