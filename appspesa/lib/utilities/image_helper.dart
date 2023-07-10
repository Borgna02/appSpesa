// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

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
    ImageSource source = ImageSource.gallery,
    int ImageQuality = 100,
  }) async {
    return await _imagePicker.pickImage(
      source: source,
      imageQuality: ImageQuality,
    );
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
