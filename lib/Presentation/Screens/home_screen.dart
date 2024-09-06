import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:admin_proteinas/Presentation/Screens/screen.dart';
import 'package:admin_proteinas/Provider/product_provider.dart';
import 'package:admin_proteinas/Presentation/Bloc/product_bloc.dart';
import '../../Model/product_model.dart';
import '../Widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productProvider = ProductProvider();
    FlutterNativeSplash.remove();

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const SideMenu(),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  showSearch<ProductoModel?>(
                    query: state.ultimoQuery,
                    context: context,
                    delegate: SearchProductDelegate(
                      initialProduct: [],
                      searchProduct:(query){
                        context.read<ProductBloc>().add(OnUltimoQuery(query));
                        return  productProvider.buscarProducto(query.toLowerCase());
                      }
                    )
                  ).then((product) {
                    if (product != null) {
                      if(context.mounted) context.read<ProductBloc>().add(ProductoEvent(product));
                      if(context.mounted) Navigator.pushNamed(context, 'product');
                    }
                  });
                },
              )
            ],
          ),
          body: const ProductListScreen(),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Nuevo'),
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<ProductBloc>().add(OnSubmitReset());
              Navigator.pushNamed(context, 'product');
            },
          ),
        );
      },
    );
  }
}
