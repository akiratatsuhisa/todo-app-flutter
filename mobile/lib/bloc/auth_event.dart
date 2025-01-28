part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

@freezed
class AuthUserSubscriptionRequested extends AuthEvent
    with _$AuthUserSubscriptionRequested {
  const factory AuthUserSubscriptionRequested() =
      _AuthUserSubscriptionRequested;
}

@freezed
class AuthLogoutPressed extends AuthEvent with _$AuthLogoutPressed {
  const factory AuthLogoutPressed() = _AuthLogoutPressed;
}
