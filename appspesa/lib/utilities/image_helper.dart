// ignore_for_file: non_constant_identifier_names

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
    int ImageQuality = 20,
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
      compressQuality: 10,
      aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 4),
    );
  }
}
