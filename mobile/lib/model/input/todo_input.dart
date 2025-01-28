import 'package:formz/formz.dart';
import 'package:mobile/model/input/validation_error.dart';
import 'package:mobile/model/input/validator_mixin.dart';

class TodoText extends FormzInput<String, ValidationError>
    with StringValidatorMixin {
  const TodoText.pure([super.value = '']) : super.pure();

  const TodoText.dirty([super.value = '']) : super.dirty();

  final label = 'text';

  static const _max = 64;

  @override
  ValidationError? validator(String? value) {
    if (!validateRequired(value)) {
      return ValidationError.required(label: label);
    }

    if (!validateMax(value, max: _max)) {
      return ValidationError.max(label: label, max: _max);
    }

    return null;
  }
}

class TodoDescription extends FormzInput<String?, ValidationError>
    with StringValidatorMixin {
  const TodoDescription.pure([super.value]) : super.pure();

  const TodoDescription.dirty([super.value]) : super.dirty();

  final label = 'description';

  static const _max = 256;

  @override
  ValidationError? validator(String? value) {
    if (!validateRequired(value)) {
      return null;
    }

    if (!validateMax(value, max: _max)) {
      return ValidationError.max(label: label, max: _max);
    }

    return null;
  }
}
