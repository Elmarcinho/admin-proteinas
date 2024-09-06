import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:admin_proteinas/Model/product_model.dart';


typedef SearchProductCallback = Future<List<ProductoModel>> Function( String query);


class SearchProductDelegate extends SearchDelegate<ProductoModel?>{

  final SearchProductCallback searchProduct;
  List<ProductoModel> initialProduct;
  StreamController<List<ProductoModel>> debouncedProductos = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchProductDelegate({
    required this.searchProduct,
    required this.initialProduct
  });

  void clearStreams(){
    debouncedProductos.close();
    isLoadingStream.close();
  }

  void _onQueryChanged( String query){

    isLoadingStream.add(true);

    if( _debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer( const Duration( milliseconds: 500),() async{

      final productos = await searchProduct(query);
      initialProduct = productos;
      debouncedProductos.add(productos);
      isLoadingStream.add(false);
    });
    
  }

  Widget _buildResultsAndSuggestions(){
    
    return StreamBuilder(
      initialData: initialProduct,
      stream: debouncedProductos.stream, 
      builder: (context, snapshot){

        final products = snapshot.data ?? [];

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) => _ProductItem(
            product: products[index],
            onProductSelect: (context, product){
              clearStreams();
              close(context, product);
            }
          )
        );
      }
    );
  }

  @override get 
  searchFieldLabel => 'Buscar producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return[
      
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if ( snapshot.data ?? false ) {
            return SpinPerfect(
                duration: const Duration(seconds: 20),
                spins: 10,
                infinite: true,
                child: IconButton(
                  onPressed: () => query = '', 
                  icon: const Icon( Icons.refresh_outlined )
                ),
              );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon( Icons.clear_outlined )
            ),
          );

        },
      ),
      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon( Icons.arrow_back_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return _buildResultsAndSuggestions();
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}

class _ProductItem extends StatelessWidget {

  final ProductoModel product;
  final Function onProductSelect;
  const _ProductItem({
    required this.product,
    required this.onProductSelect
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onProductSelect(context, product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: (product.image.isEmpty)
              ? Image.asset('assets/no-image.jpg')
              :ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  height: 100.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  image: NetworkImage(product.image),
                )
              ),
            ),
      
            const SizedBox( width: 10),
      
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(product.description),
                  Text(product.state?'ACTIVO':'INACTIVO',
                    style: TextStyle(fontSize:15 ,fontWeight: FontWeight.bold , color: product.state?Colors.green:Colors.red))
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}