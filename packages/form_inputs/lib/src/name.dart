import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  nameInvalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro email}
  const Name.pure() : super.pure('');

  /// {@macro email}
  const Name.dirty([super.value = '']) : super.dirty();

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z0-9ğüşöçİĞÜŞÖÇ ]+$',
  );

  @override
  NameValidationError? validator(String? value) {
    return _nameRegExp.hasMatch(value ?? '') ? null : NameValidationError.nameInvalid;
  }
}
