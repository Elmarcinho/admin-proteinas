import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin_proteinas/Provider/product_provider.dart';
import '../../Model/product_model.dart';
import '../../Services/services.dart';
import '../Bloc/product_bloc.dart';
import '../Widgets/widgets.dart';


class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final productProvider = ProductProvider();
    final productModel = ProductoModel();
    final size = MediaQuery.of(context).size;
    var uuid = const Uuid();

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
                child: state.id.isEmpty
                    ? const Text('Nuevo Producto')
                    : const Text('Editar Producto')),
            actions: [
              IconButton(
                icon: const Icon(Icons.photo_library_outlined),
                onPressed: () async {
                  await CameraGalleryServideImpl()
                      .selectPhoto()
                      .then((photoPath) {
                    if (photoPath == null) return;
                    if(context.mounted) context.read<ProductBloc>().add(ImageEvent(photoPath));
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () async {
                  await CameraGalleryServideImpl()
                      .takePhoto()
                      .then((photoPath) {
                    if (photoPath == null) return;
                    if(context.mounted) context.read<ProductBloc>().add(ImageEvent(photoPath));
                  });
                },
              )
            ],
          ),
          body: ListView(
            children: [
              Center(
                child: SizedBox(
                  height: size.height * 0.31,
                  width: size.height * 0.3,
                  child: _ImageGallery(
                    image: state.image,
                  ),
                ),
              ),
              const _ProductoInformation()
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: const Text('Guardar'),
            icon: const Icon(Icons.save_as_outlined),
            onPressed: () {
              context.read<ProductBloc>().add(OnSubmitEvent());
              _onSubmit(context, state, productProvider, uuid, productModel);
            },
          ),
        );
      },
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final String image;
  const _ImageGallery({required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/no-image.jpg', fit: BoxFit.cover));
    }

    late ImageProvider imageProvider;

    if (image.startsWith('http')) {
      imageProvider = NetworkImage(image);
    } else {
      imageProvider = FileImage(File(image));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: FadeInImage(
            fit: BoxFit.cover,
            image: imageProvider,
            placeholder: const AssetImage('assets/jar-loading.gif'),
          )),
    );
  }
}

class _ProductoInformation extends StatelessWidget {
  const _ProductoInformation();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomProductField(
              label: 'Nombre',
              initialValue: state.title.value,
              onChanged: (value) {
                context
                    .read<ProductBloc>()
                    .add(TitleEvent(value.toLowerCase()));
              },
              errorMessage: state.formStatus ? state.title.errorMessage : null,
            ),
           CustomProductField(
              label: 'Descripción',
              initialValue: state.description,
              onChanged: (value) {
                context
                    .read<ProductBloc>()
                    .add(DescriptionEvent(value.toLowerCase()));
              },
            ),
            Container(
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ])),
            CustomProductField(
              label: 'Precio',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              initialValue: state.price.value.toString(),
              onChanged: (value) {
                context
                    .read<ProductBloc>()
                    .add(PriceEvent(double.tryParse(value) ?? 0.0));
              },
              errorMessage: state.formStatus ? state.price.errorMessage : null,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 5,
                        offset: const Offset(0, 3))
                  ]),
              child: SwitchListTile(
                  value: state.isEnabled,
                  title: const Text('Activo',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  activeColor: Colors.green,
                  onChanged: (value) {
                    context.read<ProductBloc>().add(EnabledProductEvent(value));
                  }),
            ),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 5,
                      offset: const Offset(0, 3))
                ]
              )
            )
          ],
        );
      },
    );
  }
}

void _onSubmit( BuildContext context, ProductState state,
        ProductProvider productProvider, Uuid uuid, ProductoModel productModel) async{

  if (state.title.isValid && state.price.isValid){

    progresIndicator(context);

    final url = state.image.isNotEmpty && !state.image.startsWith('http')
        ? await productProvider.subirImagen(state.image)
        : state.image;

    if (url.startsWith('http') || url == '') {
      productModel.title = state.title.value;
      productModel.description = state.description;
      productModel.price = state.price.value;
      productModel.image = url;
      productModel.state = state.isEnabled;

      if (state.id.isEmpty) {

        await productProvider.searchProductForTitle(state.title.value).then((product) async{

          if( product.isEmpty){

            productModel.id = uuid.v1();

            await productProvider.insertarProducto(productModel).then((response) {
              if (response == 'ok') {
                if(context.mounted) context.read<ProductBloc>().add(CreateUpdateProductoEvent(productModel, true));
                if(context.mounted) context.read<ProductBloc>().add(const GetProductosEvent());
                NotificationService.showSnackbar(
                    'Producto registrado con existoso!');
                if(context.mounted) Navigator.of(context).pop();
                if(context.mounted) Navigator.of(context).pop();
              } else {
                NotificationService.showSnackbarError(response);
                if(context.mounted) Navigator.of(context).pop();
              }
            });
          }else{
            NotificationService.showSnackbarError('El producto ya existe');
            if(context.mounted) Navigator.of(context).pop();
          }
        });

      }else{

        if( state.title.value == state.backupTitleProduct){
          
          productModel.id = state.id;
          await productProvider.actualizarProducto(productModel).then((response) {
            if (response == 'ok') {
              if(context.mounted) context.read<ProductBloc>().add(CreateUpdateProductoEvent(productModel, false));
              if(context.mounted) context.read<ProductBloc>().add(const GetProductosEvent());
              NotificationService.showSnackbar(
                  'Producto actualizado con existoso!');
              if(context.mounted) Navigator.of(context).pop();
              if(context.mounted) Navigator.of(context).pop();
            } else {
              NotificationService.showSnackbarError(response);
              if(context.mounted) Navigator.of(context).pop();
            }
          });
        }else{

          await productProvider.searchProductForTitle(state.title.value).then((product) async{
            
            if( product.isEmpty){

              productModel.id = state.id;
              await productProvider.actualizarProducto(productModel).then((response) {
                if (response == 'ok') {
                  if(context.mounted) context.read<ProductBloc>().add(CreateUpdateProductoEvent(productModel, false));
                  if(context.mounted) context.read<ProductBloc>().add(const GetProductosEvent());
                  NotificationService.showSnackbar(
                      'Producto actualizado con existoso!');
                  if(context.mounted) Navigator.of(context).pop();
                  if(context.mounted) Navigator.of(context).pop();
                } else {
                  NotificationService.showSnackbarError(response);
                  if(context.mounted) Navigator.of(context).pop();
                }
              });
            }else{
              NotificationService.showSnackbarError('El producto ya existe');
              if(context.mounted) Navigator.of(context).pop();
            }
          });
        }
      }
    }else {
      NotificationService.showSnackbarError(url);
      if (context.mounted) Navigator.of(context).pop();
    }
  }else{
    NotificationService.showSnackbarError('Ingrese los campos obligatorios');
  }

}