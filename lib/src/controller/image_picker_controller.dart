import 'dart:io';
import 'package:get/get.dart';
import 'package:hris/src/repositary/api_repo.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerController extends GetxController {
  File image = File('');
  RxBool isLoading = false.obs;
  int userId = 0;
  final ImagePicker _picker = ImagePicker();
  
  pickImageFromGallery() async {
    try {
      
      // Pick an image
      final XFile? imageSelected = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30,maxHeight: 540,maxWidth: 360);
      if (imageSelected != null) {
        image = File(imageSelected.path);
        update();
        return image;
      }
    } catch (e) {
      e.toString();
    }
  }

  pickImageFromCamera() async {
    try {
      // Pick an image
      final XFile? imageSelected = await _picker.pickImage(source: ImageSource.camera,imageQuality: 30,maxHeight: 540,maxWidth: 360); // currently max image upload size is up to 2MB on server
      if (imageSelected != null) {
        image = File(imageSelected.path);
        update();
        return image;
      }
    } catch (e) {
      e.toString();
    }
  }

  uploadImageApiPost() async{
    try{
      isLoading(true);
      var response = await ApiRepo.apiUploadImage('api/upload',image);
      if(response!= null){
        // showSnackToast('Success', const SizedBox());
        return true;
      }else{
        return null;
      }
    }catch (e){
      e.toString();
    }finally{
      isLoading(false);
    }
    
  }
}
