part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(User.empty) User user,
  }) = _AuthState;

  const AuthState._();

  AuthStatus get status => user == User.empty
      ? AuthStatus.unauthenticated
      : AuthStatus.authenticated;
}
