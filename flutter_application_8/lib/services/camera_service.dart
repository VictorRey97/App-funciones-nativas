import 'package:image_picker/image_picker.dart';

class CameraService {

  final ImagePicker _picker = ImagePicker();

  Future<String?> tomarFotografia() async {

    // Abrir la cámara para capturar una fotografía
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    return foto?.path;
  }
}