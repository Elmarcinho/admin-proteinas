import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Provider/auth_provider.dart';
import '../../Services/services.dart';
import '../Bloc/login_bloc.dart';


class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final prefs = UserPreferencia();
    final authProvider = AuthProvider();
    
    return Drawer(
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero, 
            children:<Widget>[
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(  
                  image: DecorationImage(
                    image: AssetImage('assets/proteinas_logo.png'),
                    fit: BoxFit.fill
                  )
                ),
                accountName: Text(''),
                accountEmail: Text(''),
              ),
            
              SizedBox( height: size.height * 0.60),

              ListTile(
                leading: const Icon(Icons.power_settings_new, color:Colors.brown),
                title: const Text('Cerrar Sesión'),
                onTap: (){
                  context.read<LoginBloc>().add(ResetLogin());
                  authProvider.logout();
                  prefs.token='';
                  Navigator.pushReplacementNamed(context, 'login');  
                },
              ),
            ]
          )
        ],
      ),
    );
  }
}