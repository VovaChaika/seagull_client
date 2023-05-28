import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../apis/user_api.dart';
import '../models/token.dart';
import '../models/user.dart';
import '../token_interceptor.dart';

class TokenRepository {
  final Box<String> tokenBox;
  final String _key = 'access_token';

  final UserApi _userApi;

  TokenRepository(this.tokenBox, this._userApi) {
    _userApi.addInterceptor(TokenInterceptor(this));
  }

  Future<String?> getToken() async {
    return tokenBox.get(_key);
  }

  void deleteToken() {
    tokenBox.delete(_key);
  }

  String _saveToken(String token) {
     tokenBox.put(_key, token);
     return token;
  }

  Future<Token> loginUser(User user) async {
    try {
      Token token = await _userApi.loginUser(user);
       _saveToken(token.accessToken);
      return token;
    } on DioError catch (e, s) {
      rethrow;
    }
  }
}
