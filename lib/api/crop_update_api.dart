import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/crop_update_model.dart';

class CropUpdateApi {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  Future<String?> _getUserId() async {
    return await _storage.read(key: "userId");
  }

  Future<String> submitCropUpdate(CropUpdate update, {bool isUpdate = false}) async {
    final userId = await _getUserId();
    if (userId == null) throw Exception("User not logged in");

    update.memberId = userId;

    final url = isUpdate
        ? "http://192.168.8.125:5000/api/cropupdate"
        : "http://192.168.8.125:5000/api/cropsubmit";

    final response = isUpdate
        ? await _dio.put(url, data: update.toJson())
        : await _dio.post(url, data: update.toJson());

    return response.data["message"];
  }
}
