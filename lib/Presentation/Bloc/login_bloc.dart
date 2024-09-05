import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../Negocio/Validation/validation.dart';



part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {

    //on<EmailEvent>( (event, emit) => _emailEvent(event, emit) ); // esto es una forma mas detallada
    on<EmailEvent>( _emailEvent ); //forma directa que es por referencia
    on<PasswordEvent>( _passwordEvent );
    on<OnSumitEvent>( _onSubmit );
    on<ResetLogin>( _resetLogin );
  }

    void _onSubmit( OnSumitEvent event, Emitter emit){

    emit(
      state.copyWith(
        formStatus: FormStatus.posting,
        password: Password.dirty( state.password.value ),
        email: Email.dirty( state.email.value ),

      isFormValid: Formz.validate([state.email, state.password])
    ));

  }

  void _emailEvent( EmailEvent event, Emitter emit){

    final email = Email.dirty(event.email);

    emit(
        state.copyWith(
          email: email,
          isFormValid: Formz.validate([ email, state.password ])
      ));
  }

  void _passwordEvent( PasswordEvent event, Emitter emit){
  
    final password = Password.dirty(event.password);

    emit(
        state.copyWith(
          password: password,
          isFormValid: Formz.validate([ password, state.email ])
      ));
  }

  void _resetLogin( ResetLogin event, Emitter emit){

    emit(
      state.copyWith(
        formStatus: FormStatus.invalid,
        email: const Email.pure(),
        password: const Password.pure(),
        isFormValid: false
    ));

  }
}
