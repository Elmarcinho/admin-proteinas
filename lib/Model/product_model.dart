import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());


class ProductoModel {
    
  String id;
  String title;
  String description1;
  String description2;
  double price;
  String image;
  bool state;

  ProductoModel({
      this.id ='',
      this.title='',
      this.description1 ='',
      this.description2 ='',
      this.price= 0.0,
      this.image='',
      this.state=false,
  });


  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id          : json["id"],
      title       : json["title"],
      description1 : json["description1"],
      description2 : json["description2"],
      price       : json["price"].toDouble(),
      image       : json["image"],
      state       : json["state"],
  );

  Map<String, dynamic> toJson() => {
      "id"           : id,
      "title"        : title,
      "description1"  : description1,
      "description2"  : description2,
      "price"        : price,
      "image"        : image,
      "state"        : state,
  };
}