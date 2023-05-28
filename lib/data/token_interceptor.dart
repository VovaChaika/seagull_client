import 'package:dio/dio.dart';
import 'package:seagull_client/data/repositories/token_repository.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor(this.tokenRepository);

  final TokenRepository tokenRepository;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final String? token = await tokenRepository.getToken();
    if (token == null) {
      return super.onRequest(options, handler);
    }
    if (options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    return super.onRequest(options, handler);
  }

// TODO: onResponse method. Check if errorStatus is 401?
// @override
// Future onError(DioError err, ErrorInterceptorHandler handler) async {
//   if (err.response?.statusCode == 401){
//
//   }
//   throw err;
// }
}
