import 'package:dio/dio.dart';

import '../../utils/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> loginWithEmployeeId(
    String employeeId,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'employee_id': employeeId, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }
}
