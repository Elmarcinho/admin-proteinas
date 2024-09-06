import 'package:image_picker/image_picker.dart';


abstract class CameraGalleryService{

  Future<String?> takePhoto();
  Future<String?> selectPhoto();
}

class CameraGalleryServideImpl extends CameraGalleryService{

  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async{

     final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    return photo?.path;
  }

  @override
  Future<String?> takePhoto() async{
    
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      preferredCameraDevice: CameraDevice.rear
    );
  
    return photo?.path;
  }

}