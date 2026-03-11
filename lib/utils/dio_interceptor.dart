import 'package:dio/dio.dart';
import 'package:workmate_mobile/utils/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageHelper _secureStorage = SecureStorageHelper();
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
