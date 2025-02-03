import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/input/auth_input.dart';
import 'package:mobile/repository/authentication_repository.dart';

part 'register_state.dart';

part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository _authenticationRepository;

  RegisterCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(const RegisterState());

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

  Future<void> registerWithCredentials() async {
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
      await _authenticationRepository.signUp(
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
}
