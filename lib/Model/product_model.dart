import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());


class ProductoModel {
    
  String id;
  String title;
  String description;
  double price;
  String image;
  bool state;

  ProductoModel({
      this.id ='',
      this.title='',
      this.description ='',
      this.price= 0.0,
      this.image='',
      this.state=false,
  });


  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
      id          : json["id"],
      title       : json["title"],
      description : json["description"],
      price       : json["price"].toDouble(),
      image       : json["image"],
      state       : json["state"],
  );

  Map<String, dynamic> toJson() => {
      "id"           : id,
      "title"        : title,
      "description"  : description,
      "price"        : price,
      "image"        : image,
      "state"        : state,
  };
}