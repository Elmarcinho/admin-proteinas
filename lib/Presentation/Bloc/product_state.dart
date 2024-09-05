part of 'product_bloc.dart';

class ProductState extends Equatable {

  final bool formStatus;
  final bool isFormValid;
  final String id;
  final Title title;
  final Price price;
  final Description description1;
  final Description description2;
  final String image;
  final bool isEnabled;
  final List<ProductoModel> listProduct;
  final List<ProductoModel> backupListProduct;
  final bool isCreate;
  final String ultimoQuery;
  final String backupTitleProduct;


  const ProductState({
    this.formStatus = false,
    this.isFormValid = false,
    this.id='',
    this.title = const Title.dirty(''),
    this.price = const Price.dirty(0),
    this.description1 = const Description.dirty(''),
    this.description2 = const Description.dirty(''),
    this.image = '',
    this.isEnabled = false,
    this.listProduct= const [],
    this.backupListProduct= const [],
    this.isCreate = false,
    this.ultimoQuery = '',
    this.backupTitleProduct = '',
  });

  ProductState copyWith({
    bool? formStatus,
    bool? isFormValid,
    String? id,
    Title? title,
    Price? price,
    Description? description1,
    Description? description2,
    String? image,
    bool? isEnabled,
    List<ProductoModel>? listProduct,
    List<ProductoModel>? backupListProduct,
    bool? isCreate,
    String? ultimoQuery,
    String? backupTitleProduct,

  }) => ProductState(
    formStatus: formStatus ?? this.formStatus,
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    price: price ?? this.price,
    description1: description1 ?? this.description1,
    description2: description2 ?? this.description2,
    image: image ?? this.image,
    isEnabled: isEnabled ?? this.isEnabled,
    listProduct: listProduct ?? this.listProduct,
    backupListProduct: backupListProduct ?? this.backupListProduct,
    isCreate: isCreate ?? this.isCreate,
    ultimoQuery: ultimoQuery ?? this.ultimoQuery,
    backupTitleProduct: backupTitleProduct ?? this.backupTitleProduct,

  );
  
  @override
  List<Object> get props => [ formStatus, isFormValid, id, title, price, description1, description2, 
                        image, isEnabled, listProduct, backupListProduct, isCreate, ultimoQuery, backupTitleProduct ];
}


