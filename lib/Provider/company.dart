import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CompanyProvider{

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();



  Future<String> getCompany() async{
    
    String qr='';
    return await _firestore.collection('company')
      .get()
      .then(( QuerySnapshot query){
        query.docs.forEach((data){
          qr = data.data().toString();
        });
        return qr;
      });
      
  }

  Future<String> subirImagen( String path) async{

    try {
      
      final fileName = path.split('/').last;
      final ref = _storage.child('image').child(fileName);
      final dato = await ref.putFile(File(path));

      return await dato.ref.getDownloadURL();

    } catch (e) {

       return e.toString();
    }
    
  }


  Future<String> insertarCompany(String qr) async { 
    
    try {

      return await _firestore.collection('company')
                  .doc('1').set({
                    'qr' : qr
                  }).then((value) => 'ok');
    }catch (e) {

      return e.toString();
      
    }

  }

  Future<String> actualizarCompany(String qr) async { 
    
    try {

      return await _firestore.collection('company')
                  .doc('1').update({
                    'qr' : qr
                  }).then((value) => 'ok');
    } catch (e) {

      return e.toString();

    }
     
  }

}