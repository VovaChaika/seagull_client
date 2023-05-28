part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  final String? message;

  const AuthState([this.message]);

  @override
  List<Object?> get props => [message];
}

class AuthInitialState extends AuthState {
  const AuthInitialState([super.message]);
}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthErrorState extends AuthState {
  const AuthErrorState(String message) : super(message);
}
