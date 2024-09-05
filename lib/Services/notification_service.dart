import 'package:flutter/material.dart';


class NotificationService {

  static GlobalKey<ScaffoldMessengerState> mesengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbarError (String message){

    final snackbar = SnackBar(
      backgroundColor: Colors.red.withOpacity(0.9),
      content: Text( message, style: const TextStyle(color: Colors.white, fontSize: 20))
    );

    mesengerKey.currentState!.showSnackBar(snackbar);
  }


  static showSnackbar (String message){

    final snackbar = SnackBar(
      backgroundColor: Colors.greenAccent.shade700.withOpacity(0.9),
      content: Text( message, 
        style: const TextStyle(color: Colors.white, fontSize: 20))
    );

    mesengerKey.currentState!.showSnackBar(snackbar);
  }
}