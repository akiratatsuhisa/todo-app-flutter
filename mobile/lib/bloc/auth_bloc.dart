import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/model/user.dart';
import 'package:mobile/repository/authentication_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationRepository _authenticationRepository;

  AuthBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(AuthState(
          user: authenticationRepository.currentUser,
        )) {
    on<AuthUserSubscriptionRequested>(_onAuthUserSubscriptionRequested);
    on<AuthLogoutPressed>(_onAuthLogoutPressed);
  }

  Future<void> _onAuthUserSubscriptionRequested(
    AuthUserSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(AuthState(
        user: user,
      )),
      onError: addError,
    );
  }

  void _onAuthLogoutPressed(
    AuthLogoutPressed event,
    Emitter<AuthState> emit,
  ) {
    _authenticationRepository.logOut();
  }
}
