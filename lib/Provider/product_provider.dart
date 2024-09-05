import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:admin_proteinas/Model/product_model.dart';


class ProductProvider{

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();



  Future<List<ProductoModel>> getProductos() async{

    return await _firestore.collection('product')
      .orderBy('titleCategory',descending: false)
      .get()
      .then((value) => value.docs
      .map((e) => ProductoModel
      .fromJson(e.data())).toList());

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


  Future<String> insertarProducto(ProductoModel producto) async { 
    
    try {

      return await _firestore.collection('product')
                  .doc(producto.id).set( producto.toJson()).then((value) => 'ok');
    }catch (e) {

      return e.toString();
      
    }

  }

  Future<String> actualizarProducto(ProductoModel producto) async { 
    
    try {

      return await _firestore.collection('product')
                  .doc(producto.id).update(producto.toJson()).then((value) => 'ok');
    } catch (e) {

      return e.toString();

    }
     
  }

  Future<List<ProductoModel>> buscarProducto(String query) async{
    
    if(query.isEmpty) return [];
    
    return await _firestore.collection('product') 
      .where('title', isGreaterThanOrEqualTo: query) 
      .where('title', isLessThanOrEqualTo:'${query}z')  
      .get().then((value) => value.docs.map((e) => ProductoModel.fromJson(e.data())).toList());

  }

  Future<List<ProductoModel>> searchProductForTitle(String title) async{

    return await _firestore.collection('product')
      .where('title', isEqualTo: title)
      .get()
      .then((value) => value.docs
      .map((e) => ProductoModel
      .fromJson(e.data())).toList());

  }

}