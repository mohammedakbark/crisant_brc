import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

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
      _convartImageFileToBase65Formate(_fileImage!);

      notifyListeners();
    }
  }

  //  Future<File?> _compressImageFile(File imageFile) async {
  //   try {
  //     final dir = await getTemporaryDirectory();
  //     final targetPath = "${dir.absolute.path}/${DateTime.now()}.jpg";
  //     var result = await FlutterImageCompress.compressAndGetFile(
  //       imageFile.absolute.path,
  //       targetPath,
  //       quality: 100, // Adjust the quality parameter
  //       minWidth: 800, // Optionally resize the image width
  //       minHeight: 600,
  //     );

  //     return File(result!.path);
  //   } catch (e) {
  //     log("Image compression Error - ${e.toString()}");
  //     return null;
  //   }
  // }
  Map<String, dynamic>? _convertedImageFile;
  Map<String, dynamic>? get convertedImageFile => _convertedImageFile;

  _convartImageFileToBase65Formate(File file) async {
    final bytes = await file.readAsBytes();
    final converted = base64Encode(bytes);
    final fileName = path.basename(file.path);
    log(converted);
    log(fileName);

    _convertedImageFile = {'fileName': fileName, 'file': converted};
  }
}
