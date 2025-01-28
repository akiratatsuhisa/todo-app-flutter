mixin StringValidatorMixin {
  bool validateRequired(String? value) {
    return value != null && value != '';
  }

  bool validateMin(String? value, {required int min}) {
    return (value?.length ?? 0) >= min;
  }

  bool validateMax(String? value, {required int max}) {
    return (value?.length ?? 0) <= max;
  }

  bool validateBetween(String? value, {required int min, required int max}) {
    final length = value?.length ?? 0;
    return length >= min && length <= max;
  }

  bool validateRegExp(String? value, {required RegExp regExp}) {
    return regExp.hasMatch(value ?? '');
  }
}
