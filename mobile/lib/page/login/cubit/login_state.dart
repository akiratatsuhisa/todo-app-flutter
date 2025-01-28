part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(AuthEmail.pure()) AuthEmail email,
    @Default(AuthPassword.pure()) AuthPassword password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    String? errorMessage,
  }) = _LoginState;
}
