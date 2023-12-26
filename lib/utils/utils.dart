import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(
      source: source, maxWidth: 300, imageQuality: 100);
  if (_file != null) {
    return _file.readAsBytes();
  }
  print("No image selected");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
