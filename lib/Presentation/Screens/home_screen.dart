import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    FlutterNativeSplash.remove();
    
    return Container( child: Text('Hello'),);
  }
}