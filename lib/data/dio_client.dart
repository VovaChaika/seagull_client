import 'package:dio/dio.dart';

class DioClient {
  final Dio dio = Dio();
  final String _url = "http://192.168.3.77:5000/api"; // LAN IP

  DioClient() {
    dio.options = BaseOptions(
        baseUrl: _url,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 8));
  }
}
