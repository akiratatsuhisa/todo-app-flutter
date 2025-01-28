import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/input/auth_input.dart';
import 'package:mobile/repository/authentication_repository.dart';

part 'login_state.dart';

part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const LoginState());

  void emailChanged(String value) {
    final email = AuthEmail.dirty(value);
    emit(
      state.copyWith(
        email: email,
      ),
    );
  }

  void passwordChanged(String value) {
    final password = AuthPassword.dirty(value);
    emit(
      state.copyWith(
        password: password,
      ),
    );
  }

  Future<void> logInWithCredentials() async {
    if (!Formz.validate([state.email, state.password])) {
      emit(
        state.copyWith(
          email: AuthEmail.dirty(state.email.value),
          password: AuthPassword.dirty(state.password.value),
        ),
      );
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    } finally {
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      await _authenticationRepository.logInWithGoogle();

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    } finally {
      emit(state.copyWith(status: FormzSubmissionStatus.initial));
    }
  }
}
