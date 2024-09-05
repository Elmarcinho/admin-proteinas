import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin_proteinas/Model/product_model.dart';
import 'package:admin_proteinas/Provider/product_provider.dart';
import 'package:formz/formz.dart';

import '../../Negocio/Validation/validation.dart';

part 'product_event.dart';
part 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {

  final ProductProvider productProvider;

  ProductBloc(this.productProvider) : super(const ProductState()) {

    on<GetProductosEvent>( _onGetProductos);
    on<CreateUpdateProductoEvent>( _onCreateUpdateProducto);
    on<ProductoEvent>( _onProducto);
    on<OnSubmitEvent>( _onSubmit);
    on<OnSubmitReset>( _onReset);
    on<TitleEvent>( _onTitleChanged);
    on<PriceEvent>( _onPriceChanged);
    on<Description1Event>( _onDescription1Changed);
    on<Description2Event>( _onDescription2Changed);
    on<EnabledProductEvent>( _onEnableProductChanged);
    on<ImageEvent>( _onImageChanged);
  }

  void _onGetProductos( GetProductosEvent event, Emitter emit) async{
    

    final productos = await productProvider.getProductos();

    emit( 
      state.copyWith(
        listProduct: productos,
        backupListProduct: productos
      )
    );
  }

  void _onCreateUpdateProducto( CreateUpdateProductoEvent event, Emitter emit) async{

    if(event.isCreate){
        
        emit(
          state.copyWith(
            listProduct: [event.product,...state.listProduct]

          ),
        );
    
    }else{ 
      emit(
        state.copyWith(
          listProduct: state.listProduct.map(
            (elemento) => (elemento.id==event.product.id)? event.product : elemento).toList()
        )
      );
    }

  }

  void _onProducto( ProductoEvent event, Emitter emit){
    
    emit(
      state.copyWith(
        id: event.product.id,
        title: Title.dirty(event.product.title),
        description1: Description.dirty(event.product.description1),
        description2: Description.dirty(event.product.description2),
        price: Price.dirty(event.product.price),
        image: event.product.image,
        isEnabled: event.product.state,
        backupTitleProduct: event.product.title,
        isFormValid: Formz.validate([Title.dirty(event.product.title), Description.dirty(event.product.description1),
                      Description.dirty(event.product.description2), Price.dirty(event.product.price)])
      )
    );
  }

  void _onSubmit( OnSubmitEvent event, Emitter emit){

    final title = Title.dirty(state.title.value);
    final description1 = Description.dirty(state.description1.value);
    final description2 = Description.dirty(state.description2.value);
    final price =  Price.dirty(state.price.value);

    emit(
      state.copyWith(
        formStatus: true,
        title: title,
        description1: description1,
        description2: description2,
        price: price,
        isFormValid: Formz.validate([title, description1, description2, price])
      )
    );
  }

  void _onReset( OnSubmitReset event, Emitter emit){

    emit(
      state.copyWith(
        formStatus: false,
        id: '',
        title: const Title.dirty(''),
        price: const Price.dirty(0),
        description1: const Description.dirty(''),
        description2: const Description.dirty(''),
        image: '',
        isEnabled: false,
      )
    );
  }

  void _onTitleChanged( TitleEvent event, Emitter emit ) {
    
    final title = Title.dirty(event.title);

    emit(
      state.copyWith(
        title: title,
        isFormValid: Formz.validate([title, state.price])
      )
    );
  }

  void _onPriceChanged( PriceEvent event, Emitter emit){
    
    final price = Price.dirty(event.price);

    emit(
      state.copyWith(
        price: price,
        isFormValid: Formz.validate([price, state.title])
      )
    );
  }

   void _onDescription1Changed( Description1Event event, Emitter emit){

    final description1 = Description.dirty(event.description);

    emit(
      state.copyWith(
        description1: description1,
        isFormValid: Formz.validate([state.title, description1, state.description2, state.price])
      )
    );
  }

  void _onDescription2Changed( Description2Event event, Emitter emit){

    final description2= Description.dirty(event.description);

    emit(
      state.copyWith(
        description2: description2,
        isFormValid: Formz.validate([state.title, state.description1, description2, state.price])
      )
    );
  }

  void _onImageChanged( ImageEvent event, Emitter emit){
    
    emit(
      state.copyWith(
        image: event.path
      )
    );
  }

  void _onEnableProductChanged( EnabledProductEvent event, Emitter emit){

    emit(
      state.copyWith(
        isEnabled: event.isEnable
      )
    );
  }

}




