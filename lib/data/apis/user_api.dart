import 'package:dio/dio.dart';

import '../dio_client.dart';
import '../models/token.dart';
import '../models/user.dart';
import '../token_interceptor.dart';

class UserApi {
  final DioClient _dioClient;
  final String _usersUrl = '/users';

  UserApi(this._dioClient);

  Future<Token> loginUser(User user) async {
    try {
      FormData formData = FormData.fromMap(user.toJson()); // to Json
      final Response response =
          await _dioClient.dio.post("$_usersUrl/login", data: formData);
      return Token.fromJson(response.data);
    } on DioError catch (e, s) {
      rethrow;
    }
  }

  void addInterceptor(TokenInterceptor tokenInterceptor){
    _dioClient.dio.interceptors.add(tokenInterceptor);
  }
}
