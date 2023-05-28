import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/user.dart';
import '../../data/repositories/token_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late final TokenRepository _tokenRepository;

  AuthCubit(this._tokenRepository) : super(const AuthInitialState());

  void tryAutoLogin() async {
    String? accessToken = await _tokenRepository.getToken();
    if (accessToken == null) return;
    emit(AuthSuccessState());
  }

  void login(User user) async {
    if (user.username.isEmpty || user.password.isEmpty) {
      return emit(const AuthErrorState("Either Login or Username is empty"));
    }
    emit(AuthLoadingState());
    // 1 sec request delay
    Future<AuthState> future =
        Future.delayed(const Duration(seconds: 1), () async {
      try {
        await _tokenRepository.loginUser(user);
        return AuthSuccessState();
      } on DioError catch (e) {
        if (e.response?.statusCode == 400) {
          return const AuthErrorState(
              "Login failed. Password or Login is incorrect!");
        }
        return const AuthErrorState("Time is out!");
      }
    });
    emit(await future);
  }

  void logout() {
    _tokenRepository.deleteToken();
    emit(const AuthInitialState());
  }

  void logoutBecause(String reason) {
    _tokenRepository.deleteToken();
    emit(AuthInitialState(reason));
  }
}
