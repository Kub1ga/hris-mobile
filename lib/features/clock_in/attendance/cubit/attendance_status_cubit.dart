import 'package:bloc/bloc.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/attendance_today_status.dart';

class AttendanceStatusCubit extends Cubit<AttendanceTodayStatus> {
  AttendanceStatusCubit() : super(AttendanceTodayStatus.idle);

  void changeStatusFromServer(AttendanceTodayStatus status) {
    if (state == status) return;
    emit(status);
  }
}
