part of 'login_bloc.dart';

enum FormStatus { invalid, valid, validating, posting }

class LoginState extends Equatable {
  
  final FormStatus formStatus;
  final bool isFormValid;
  final Email email;
  final Password password;
  final bool authStatus;

  const LoginState({
    this.formStatus = FormStatus.invalid, 
    this.isFormValid = false,
    this.email = const Email.pure(), 
    this.password = const Password.pure(),
    this.authStatus = false
  });

  LoginState copyWith({
    FormStatus? formStatus,
    bool? isFormValid,
    Email? email,
    Password? password,
    bool? authStatus
  }) => LoginState(
    formStatus: formStatus ?? this.formStatus,
    isFormValid: isFormValid ?? this.isFormValid,
    email: email ?? this.email,
    password: password ?? this.password,
    authStatus: authStatus ?? this.authStatus
  );
  
  @override
  List<Object> get props => [formStatus, isFormValid, email, password, authStatus];
}


