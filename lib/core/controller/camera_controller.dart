import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraController with ChangeNotifier {
  File? _fileImage;
  File? get fileImage => _fileImage;
  String? _fileName;
  String? get fileName => _fileName;
  Future<void> onPickImage() async {
    print('object');
    final imagePicker = ImagePicker();
    final xfile = await imagePicker.pickImage(source: ImageSource.camera);

    if (xfile != null) {
      _fileName = xfile.name;
      _fileImage = File(xfile.path);

      notifyListeners();
    }
  }
}
