import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PickAndCropImage{
  Future pickAndCropImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source, maxWidth: 1024, maxHeight: 1024, requestFullMetadata: true, imageQuality: 85);
      if (image == null) return null;

      File selFile = File(image.path);
      int fileSizeInBytes = await selFile.length();
      log('File Size => $fileSizeInBytes');
      
      if(fileSizeInBytes <= 5242880){    // check if image is under 5 MB
        //Crop Image
        final croppedImage = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // 1:1 aspect ratio
          maxWidth: 1024,
          maxHeight: 1024,
          cropStyle: CropStyle.rectangle, // Change to circle for circular crop
          compressQuality: 100, // Image quality from 0 to 100
        );
        return File(croppedImage!.path);
      } else {
        showMessage('Notice', 'Image size too large, cannot be used');
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to upload image: $e");
    }
  }
}