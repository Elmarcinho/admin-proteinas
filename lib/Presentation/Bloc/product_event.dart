part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetProductosEvent extends ProductEvent { 
  const GetProductosEvent();
}

class CreateUpdateProductoEvent extends ProductEvent { 
  final ProductoModel product;
  final bool isCreate;
  const CreateUpdateProductoEvent(this.product, this.isCreate);
}

class ProductoEvent extends ProductEvent { 
  final ProductoModel product;
  const ProductoEvent(this.product);
}

class OnSubmitEvent extends ProductEvent { }

class OnSubmitReset extends ProductEvent { }

class TitleEvent extends ProductEvent {
  final String title;
  const TitleEvent(this.title);
}

class PriceEvent extends ProductEvent {
  final double price;
  const PriceEvent(this.price);
}

class DescriptionEvent extends ProductEvent{
   final String description;
  const DescriptionEvent(this.description);
}

class EnabledProductEvent extends ProductEvent {
  final bool isEnable;
  const EnabledProductEvent(this.isEnable);
}

class ImageEvent extends ProductEvent{
   final String path;
  const ImageEvent(this.path);
}

class OnUltimoQuery extends ProductEvent{
  final String ultimoQuery;
  const OnUltimoQuery(this.ultimoQuery);
}