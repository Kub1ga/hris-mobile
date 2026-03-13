import 'package:dio/dio.dart';
import 'package:workmate_mobile/utils/dio_client.dart';

class FaceRepository {
  final Dio _dio = DioClient().dio;

  Future<String?> getSelfieUrl() async {
    final response = await _dio.get("/attendance/register");

    if (response.statusCode == 200) {
      return response.data["selfie_url"];
    }

    return null;
  }
}
