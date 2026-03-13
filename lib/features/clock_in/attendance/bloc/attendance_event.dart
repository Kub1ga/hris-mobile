part of 'attendance_bloc.dart';

sealed class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

final class FetchTodayAttendance extends AttendanceEvent {}

final class CheckFaceRecog extends AttendanceEvent {}
