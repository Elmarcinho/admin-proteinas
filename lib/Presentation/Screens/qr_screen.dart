import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:admin_proteinas/Presentation/Bloc/company_bloc.dart';

import '../../Services/camera_gallery_service.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CompanyBloc, CompanyState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Código Qr'),
            actions: [
              IconButton(
                icon: const Icon(Icons.photo_library_outlined),
                onPressed: () async {
                  await CameraGalleryServideImpl()
                      .selectPhoto()
                      .then((photoPath) {
                    if (photoPath == null) return;
                    if(context.mounted) context.read<CompanyBloc>().add(ImageEvent(photoPath));
                  });
                },
              ),
            ],
          ),
          body: Column(
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
            ],
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
