import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'ACCESS_TOKEN';

  static const String _faceEmbeddingKey = "FACE_EMBEDDING";

  // Future<void> saveEmbeddingImage(List<double> embedding) async {
  //   final existing = await getEmbeddingImage();

  //   if (existing == null) {
  //     final jsonString = jsonEncode(embedding);

  //     await _storage.write(key: _faceEmbeddingKey, value: jsonString);

  //     log("SUCCESS SAVE EMBEDDING IMAGE");
  //   } else {
  //     log("EMBEDDING SUDAH ADA, TIDAK DISIMPAN LAGI");
  //   }
  // }

  // Future<List<double>?> getEmbeddingImage() async {
  //   final jsonString = await _storage.read(key: _faceEmbeddingKey);

  //   if (jsonString == null) return null;

  //   final List decoded = jsonDecode(jsonString);
  //   log("SUCCESS GET EMBEDDING IMAGE = $decoded");

  //   return decoded.map((e) => (e as num).toDouble()).toList();
  // }

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
