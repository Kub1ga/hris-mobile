import 'package:dio/dio.dart';

import '../../utils/dio_client.dart';

class ClockInRepository {
  final Dio _dio = DioClient().dio;

  Future<void> clockIn({
    required String companyId,
    required String employeeId,
    required double latitude,
    required double longitude,
    required String notes,
    required String selfieUrl,
  }) async {
    try {
      await _dio.post(
        "/attendance/clock-in",
        data: {
          "companyID": companyId,
          "employeeID": employeeId,
          "latitude": latitude,
          "longitude": longitude,
          "notes": notes,
          "selfie_url": selfieUrl,
        },
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }
}
