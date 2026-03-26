import 'package:dio/dio.dart';

import '../../../utils/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return response.data;
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan";

      if (e.response?.data != null) {
        final data = e.response?.data;
        if (data['errors'] != null && data['errors'] is Map) {
          errorMessage = (data['errors'] as Map).values.first.toString();
        } else {
          errorMessage = data['message'] ?? errorMessage;
        }
      }
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
      String errorMessage = "Terjadi kesalahan";

      if (e.response?.data != null) {
        final data = e.response?.data;
        if (data['errors'] != null && data['errors'] is Map) {
          errorMessage = (data['errors'] as Map).values.first.toString();
        } else {
          errorMessage = data['message'] ?? errorMessage;
        }
      }
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String phoneNumber,
    required String companyId,
    required String password,
    required bool isTncAccepted,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'company_code': companyId,
          'email': email,
          'is_tnc_accepted': isTncAccepted,
          'password': password,
          'phone_number': phoneNumber,
        },
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> requestOtp({required String email}) async {
    try {
      final response = await _dio.post(
        'auth/otp/request',
        data: {'email': email},
      );
      return response.data;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }
}
