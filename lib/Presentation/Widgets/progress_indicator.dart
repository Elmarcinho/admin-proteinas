import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


  progresIndicator(BuildContext context) {
 
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return  const Center(
          child:  SpinKitCircle(
            color: Colors.white,
            size: 50.0,
          ),
        );
      }
    );

  }
