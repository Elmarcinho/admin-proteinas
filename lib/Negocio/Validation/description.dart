import 'package:formz/formz.dart';

// Define input validation errors
enum DescriptionError { length }

// Extend FormzInput and provide the input type and error type.
class Description extends FormzInput<String, DescriptionError> {


  // Call super.pure to represent an unmodified form input.
  const Description.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Description.dirty( super.value ) : super.dirty();


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == DescriptionError.length) return 'Máximo 16 caracteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  DescriptionError? validator(String value) {
    
    if ( value.length > 16 ) return DescriptionError.length;

    return null;
  }
}