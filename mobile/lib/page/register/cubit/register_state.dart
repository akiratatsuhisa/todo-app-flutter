part of 'register_cubit.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(AuthEmail.pure()) AuthEmail email,
    @Default(AuthPassword.pure()) AuthPassword password,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    String? errorMessage,
  }) = _RegisterState;
}
