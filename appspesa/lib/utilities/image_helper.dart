// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:appspesa/widgets/scegli_sorgente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;

  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({
    required BuildContext context,
    int imageQuality = 100,
  }) async {
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SorgenteChoiceBox(); // Utilizza una funzione di builder per restituire il widget
      },
    );

    if (imageSource != null) {
      return await _imagePicker.pickImage(
        source: imageSource,
        imageQuality: imageQuality,
      );
    }

    return null;
  }

  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    return await _imageCropper.cropImage(
      cropStyle: cropStyle,
      sourcePath: file.path,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );
  }

  Future<Uint8List> compressImage(
    File imageFile,
    int maxWidth,
    int maxHeight,
    int quality,
  ) async {
    final result = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: quality,
    );

    return result!;
  }
}
