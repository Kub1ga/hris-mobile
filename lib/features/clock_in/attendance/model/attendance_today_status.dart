enum AttendanceTodayStatus { idle, clockedIn, onBreak, clockedOut }

extension AttendanceStatusParser on String {
  AttendanceTodayStatus toAttendanceStatus() {
    switch (this) {
      case "clocked_in":
        return AttendanceTodayStatus.clockedIn;

      case "on_break":
        return AttendanceTodayStatus.onBreak;

      case "clocked_out":
        return AttendanceTodayStatus.onBreak;

      default:
        return AttendanceTodayStatus.idle;
    }
  }
}
