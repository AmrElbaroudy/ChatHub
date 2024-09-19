//show snack bar
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void showSnackBar( BuildContext context,String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

//pick image from gallery or camera
Future<File?> pickImage(
    {required BuildContext context,
      required bool isCamera,
      required Function(String) onFail,
    }) async {
  File? image;
  if (isCamera) {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.camera);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      onFail(e.toString());
    }
  } else {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      onFail(e.toString());
    }}
    return image;
  }
//crop image