import 'package:dio/dio.dart';
import 'package:workmate_mobile/features/clock_in/attendance/model/attendance_today_models.dart';
import 'package:workmate_mobile/utils/dio_client.dart';

class AttendanceRepository {
  final Dio _dio = DioClient().dio;

  Future<TodayAttendanceModel> getTodayAttendance() async {
    try {
      final response = await _dio.get("/attendance/today");
      return TodayAttendanceModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }

  Future<void> checkFaceRecogUser() async {
    try {
      await _dio.get("/attendance/register");
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }

  Future<void> registerSelfie({required String url}) async {
    try {
      await _dio.post("/attendance/register", data: {"selfie_url": url});
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }
}
