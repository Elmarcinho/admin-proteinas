import 'package:shared_preferences/shared_preferences.dart';


class UserPreferencia {

  static late SharedPreferences _prefs;
  

  static Future initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
  // GET y SET del Token
  String get token{
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
      _prefs.setString('token', value);
  }

  String get nombreUsuario {
    return _prefs.getString('nombreUsuario') ?? '';
  }

  set nombreUsuario( String value ) {
    _prefs.setString('nombreUsuario', value);
  }

  String get email {
    return _prefs.getString('email') ?? '';
  }

  set email( String value ) {
    _prefs.setString('email', value);
  }

  String get rol {
    return _prefs.getString('rol') ?? '';
  }

  set rol( String value ) {
    _prefs.setString('rol', value);
  }

  int get cedula {
    return _prefs.getInt('cedula') ?? 0;
  }

  set cedula( int value ) {
    _prefs.setInt('cedula', value);
  }


}
