part of 'attendance_bloc.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

final class AttendanceInitial extends AttendanceState {}

final class AttendanceSuccess extends AttendanceState {
  final TodayAttendanceModel todayAttendanceModel;

  const AttendanceSuccess({required this.todayAttendanceModel});
}

final class AttendanceError extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}
