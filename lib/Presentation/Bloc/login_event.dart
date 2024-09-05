part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class EmailEvent extends LoginEvent {
  final String email;
  const EmailEvent(this.email);
}

class PasswordEvent extends LoginEvent {
  final String password;
  const PasswordEvent(this.password);
}

class OnSumitEvent extends LoginEvent { }

class ResetLogin extends LoginEvent { }
