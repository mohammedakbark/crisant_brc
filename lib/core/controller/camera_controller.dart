import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.path, // Input file path
      '${file.path}${DateTime.timestamp()}.jpg', // Output file path
      quality: 80, // Quality: 0-100 (lower = more compression, less quality)
      minWidth: 800, // Resize width
      minHeight: 800, // Resize height
    );
    final newFile = File(compressedImage!.path);
    final bytes = await newFile.readAsBytes();
    final converted = base64Encode(bytes);
    final fileName = path.basename(file.path);
    log(converted);
    log(fileName);

    _convertedImageFile = {'fileName': fileName, 'file': converted};
  }

  Future clearCameraData() async {
    _fileImage = null;
    _fileName = null;
    _convertedImageFile = null;
  }

  static Uint8List base64ToBlob(String base64String) {
    return base64Decode(base64String);
  }

  static String blobToBase64(Uint8List blob) {
    return base64Encode(blob);
  }
}
