import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:admin_proteinas/Presentation/Widgets/widgets.dart';
import 'package:admin_proteinas/Presentation/Bloc/login_bloc.dart';

import '../../Provider/auth_provider.dart';
import '../../Services/services.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Icon Banner
                const Icon(
                  Icons.production_quantity_limits_rounded,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 80),

                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {

    FlutterNativeSplash.remove();
    final authProvider = AuthProvider();
    final textStyles = Theme.of(context).textTheme;

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Text('Login', style: textStyles.titleLarge),
                const SizedBox(height: 90),
                CustomTextFormField(
                    label: 'Correo',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      context.read<LoginBloc>().add(EmailEvent(value));
                    },
                    errorMessage: state.formStatus.index == 3
                        ? state.email.errorMessage
                        : null),
                const SizedBox(height: 30),
                CustomTextFormField(
                    label: 'Contraseña',
                    obscureText: true,
                    onChanged: (value) {
                      context.read<LoginBloc>().add(PasswordEvent(value));
                    },
                    errorMessage: state.formStatus.index == 3
                        ? state.password.errorMessage
                        : null),
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CustomFilledButton(
                      text: 'Ingresar',
                      buttonColor: Colors.black,
                      onPressed: () => _login(context, state, authProvider),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _login(BuildContext context, LoginState state, AuthProvider authProvider) async {
  
  context.read<LoginBloc>().add(OnSumitEvent());

  if(state.isFormValid){

    progresIndicator(context);
    await authProvider.login(state.email.value, state.password.value).then((response) => {
      if (response == 'ok') {

      if(context.mounted) Navigator.pushReplacementNamed(context, 'home')
      // state.copyWith( authStatus: true)
      
    }else{ 
      NotificationService.showSnackbarError(response),
      if(context.mounted) Navigator.of(context).pop()
    }

    });

  } 
}