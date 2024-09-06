import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin_proteinas/Model/product_model.dart';
import '../Bloc/product_bloc.dart';
import '../Widgets/widgets.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {

        if (state.listProduct.isEmpty) return const Center(child: CircularProgressIndicator());

        return RefreshIndicator(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.66,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1
              ),
              itemCount: state.listProduct.length,
              itemBuilder: (contex, i) => _crearItem(context, state.listProduct[i]),
            ),
            onRefresh: () async {
              refresProductos(context);
            },
        );
      },
    );
  }

  Future<void> refresProductos(BuildContext context) async {
    progresIndicator(context);

    Timer(const Duration(seconds: 2), () async {
      context.read<ProductBloc>().add(const GetProductosEvent());
      Navigator.of(context).pop();
    });

    return await Future.delayed(const Duration(seconds: 2));
  }

    Widget _crearItem(BuildContext context, ProductoModel producto) {

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 120.0,
                width: double.infinity,
                child: (producto.image.isEmpty)
                    ? Image.asset('assets/no-image.jpg')
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: FadeInImage(
                          placeholder:
                              const AssetImage('assets/jar-loading.gif'),
                          height: 100.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          image: NetworkImage(producto.image),
                        )),
              ),
              const SizedBox( height: 10),

              SizedBox(
                  width: double.infinity,
                  child: Text('Bs. ${producto.price}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold))
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                    '${producto.title[0].toUpperCase()}${producto.title.substring(1)}',
                    style: const TextStyle(fontSize: 15))),
              Expanded(
                child: SizedBox(
                  width: double.infinity, 
                  child: Text(producto.description.isNotEmpty
                          ?'${producto.description[0].toUpperCase()}${producto.description.substring(1)}'
                          :''
                  )
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(producto.state ? 'ACTIVO' : 'INACTIVO',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: producto.state ? Colors.green : Colors.red)),
              ),
            ],
          ),
        ),
        onTap: () {
          context.read<ProductBloc>().add(ProductoEvent(producto));
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
