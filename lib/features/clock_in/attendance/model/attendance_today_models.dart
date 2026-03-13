class TodayAttendanceModel {
  TodayAttendanceModel({
    required this.attendanceId,
    required this.clockInAt,
    required this.clockOutAt,
    required this.isOnBreak,
    required this.notes,
    required this.openBreakStartAt,
    required this.status,
  });

  final String? attendanceId;
  final String? clockInAt;
  final String? clockOutAt;
  final bool? isOnBreak;
  final String? notes;
  final String? openBreakStartAt;
  final String? status;

  factory TodayAttendanceModel.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceModel(
      attendanceId: json["attendance_id"],
      clockInAt: json["clock_in_at"],
      clockOutAt: json["clock_out_at"],
      isOnBreak: json["is_on_break"],
      notes: json["notes"],
      openBreakStartAt: json["open_break_start_at"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "attendance_id": attendanceId,
    "clock_in_at": clockInAt,
    "clock_out_at": clockOutAt,
    "is_on_break": isOnBreak,
    "notes": notes,
    "open_break_start_at": openBreakStartAt,
    "status": status,
  };
}
