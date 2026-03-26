import 'package:dio/dio.dart';
import 'package:workmate_mobile/features/profile/models/user_profile_models.dart';

import '../../utils/dio_client.dart';

class ProfileRepository {
  final Dio _dio = DioClient().dio;

  Future<UserProfileModels> getUserProfile() async {
    try {
      final response = await _dio.get("/employee/profile");
      return UserProfileModels.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['error'] ?? "Terjadi kesalahan tidak diketahui";
      throw errorMessage;
    }
  }
}
