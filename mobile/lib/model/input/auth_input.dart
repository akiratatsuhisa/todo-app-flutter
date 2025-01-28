import 'package:formz/formz.dart';
import 'package:mobile/model/input/validation_error.dart';

class AuthEmail extends FormzInput<String, ValidationError> {
  const AuthEmail.pure([super.value = '']) : super.pure();

  const AuthEmail.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  final label = 'email';

  @override
  ValidationError? validator(String? value) {
    return _emailRegExp.hasMatch(value ?? '')
        ? null
        : ValidationError.invalid(label: label);
  }
}

class AuthPassword extends FormzInput<String, ValidationError> {
  const AuthPassword.pure([super.value = '']) : super.pure();

  const AuthPassword.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp = RegExp(r'^.+$');

  final label = 'password';

  @override
  ValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : ValidationError.invalid(label: label);
  }
}
