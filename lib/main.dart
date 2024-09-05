import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:admin_proteinas/Presentation/Bloc/product_bloc.dart';
import 'package:admin_proteinas/Provider/product_provider.dart';
import 'package:admin_proteinas/firebase_options.dart';
import 'Presentation/Bloc/login_bloc.dart';
import 'Presentation/Screens/screen.dart';
import 'Services/services.dart';

void main() async{

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferencia.initPrefs();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final prefs = UserPreferencia();
  final productProvider = ProductProvider();

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => ProductBloc(productProvider)..add(const GetProductosEvent())),
      ], 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Proteinas',
        initialRoute: prefs.token !='' ? 'home' :  'login',
        scaffoldMessengerKey: NotificationService.mesengerKey,
        routes: {
          'login'          : ( BuildContext context) => const LoginScreen(),
          'home'           : ( BuildContext context) => const HomeScreen(),
        },
      )
    );
    
  }
}
