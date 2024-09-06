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
    on<DescriptionEvent>( _onDescription1Changed);
    on<EnabledProductEvent>( _onEnableProductChanged);
    on<ImageEvent>( _onImageChanged);
    on<OnUltimoQuery>( _onUltimoQuery);
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
        description: event.product.description,
        price: Price.dirty(event.product.price),
        image: event.product.image,
        isEnabled: event.product.state,
        backupTitleProduct: event.product.title,
        isFormValid: Formz.validate([Title.dirty(event.product.title), Price.dirty(event.product.price)])
      )
    );
  }

  void _onSubmit( OnSubmitEvent event, Emitter emit){

    final title = Title.dirty(state.title.value);
    final description = state.description;
    final price =  Price.dirty(state.price.value);

    emit(
      state.copyWith(
        formStatus: true,
        title: title,
        description: description,
        price: price,
        isFormValid: Formz.validate([title, price])
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
        description: '',
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

   void _onDescription1Changed( DescriptionEvent event, Emitter emit){

    emit(
      state.copyWith(
        description: event.description,
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

  void _onUltimoQuery( OnUltimoQuery event, Emitter emit) async{
    
    emit( 
      state.copyWith(
        ultimoQuery: event.ultimoQuery
      )
    );
  }

}




