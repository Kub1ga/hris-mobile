import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:workmate_mobile/features/clock_in/attendance/cubit/attendance_status_cubit.dart';
import 'package:workmate_mobile/features/clock_in/attendance/cubit/face_recog_status_cubit.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/attendance_today_models.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/attendance_today_status.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/face_recog_status.dart';
import 'package:workmate_mobile/features/repository/attendance_repository.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceRepository attendanceRepository = AttendanceRepository();
  AttendanceStatusCubit status;
  FaceRecogStatusCubit faceStatus;
  AttendanceBloc({
    required this.attendanceRepository,
    required this.status,
    required this.faceStatus,
  }) : super(AttendanceInitial()) {
    on<FetchTodayAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final response = await attendanceRepository.getTodayAttendance();
        status.changeStatusFromServer(response.status!.toAttendanceStatus());
        emit(AttendanceSuccess(todayAttendanceModel: response));
      } catch (e) {
        emit(AttendanceError());
      }
    });

    on<CheckFaceRecog>((event, emit) async {
      try {
        log("CHECK FACE RECOG", name: "CHECK FACE REGISTERED");
        await attendanceRepository.checkFaceRecogUser();
        faceStatus.changeFaceRecogStatus(FaceRecogStatus.success);
      } catch (e) {
        log(e.toString(), name: "CHECK FACE REGISTERED");
        faceStatus.changeFaceRecogStatus(FaceRecogStatus.error);
      }
    });
  }
}
