import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:admin_proteinas/Services/user_preferencia_service.dart';


class AuthProvider{

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _prefUser = UserPreferencia();
  

  Future<String> login(String email, String password) async{

    try {
      final auth = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(auth.user!.uid.isNotEmpty){
          final token = await auth.user!.getIdToken();
          final user = await _firestore.collection('user').doc(auth.user!.uid).get().then((value) => value.data());

          _prefUser.token = token!;
          _prefUser.nombreUsuario = user!['name'];
          _prefUser.rol = user['role'];

        return 'ok';
      }else{
        return 'Error al iniciar sección';
      }
    
    }on FirebaseAuthException catch(e) {

      switch (e.code) {
      case 'invalid-credential':
        return 
          'Credenciales inválida por favor verifique su correo y contraseña';
      case 'invalid-email':
        return 
          'El correo no es válido';
      case 'user-disabled':
        return 
          'Este usuario ha sido deshabilitado. Por favor, póngase en contacto con el soporte para obtener ayuda.';
      case 'user-not-found':
        return 
          'No se encuentra el correo electrónico, cree una cuenta.';
      case 'wrong-password':
        return
          'Contraseña incorrecta. Por favor, pruebe de nuevo.';
      default:
        return 'Se produjo una excepción desconocida' ;
    }

    }catch  (e){
      throw e.toString();
    }
    
  }

  Future<void> logout() async {

    await _auth.signOut();

  }


}