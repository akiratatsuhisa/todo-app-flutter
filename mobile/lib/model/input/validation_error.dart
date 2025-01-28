enum ValidationErrorCode {
  invalid,
  required,
  min,
  max,
  between,
  email,
}

final class ValidationError {
  final ValidationErrorCode code;
  final String message;

  ValidationError._({required this.code, required this.message});

  ValidationError.invalid({required String label})
      : this._(
          code: ValidationErrorCode.invalid,
          message: 'Invalid [$label]',
        );

  ValidationError.required({required String label})
      : this._(
          code: ValidationErrorCode.required,
          message: 'The field [$label] is required',
        );

  ValidationError.min({required String label, required int min})
      : this._(
          code: ValidationErrorCode.min,
          message: 'The field [$label] must be at least $min characters long',
        );

  ValidationError.max({required String label, required int max})
      : this._(
          code: ValidationErrorCode.max,
          message: 'The field [$label] must be at most $max characters long',
        );

  ValidationError.between(
      {required String label, required int min, required int max})
      : this._(
          code: ValidationErrorCode.between,
          message:
              'The field [$label] must be between $min and $max characters long',
        );

  ValidationError.email({required String label})
      : this._(
          code: ValidationErrorCode.email,
          message: 'The field [$label] must be a valid email address',
        );
}
