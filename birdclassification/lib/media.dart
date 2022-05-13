import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Media {
  final ImagePicker _picker = ImagePicker();

  Future<String?> openCamera() async {
    XFile? _tempImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 900);
    if (_tempImage != null) {
      Uint8List byte = await _tempImage.readAsBytes();
      return Future.value(base64Encode(byte.toList()));
    }
    return Future.value(null);
  }

  Future<String?> openGallery() async {
    XFile? _tempImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 600,
        maxWidth: 900);
    if (_tempImage != null) {
      Uint8List byte = await _tempImage.readAsBytes();
      return Future.value(base64Encode(byte.toList()));
    }
    return Future.value(null);
  }

  Future<String> createFileFromString(String content) async {
    Uint8List bytes = base64.decode(content);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
