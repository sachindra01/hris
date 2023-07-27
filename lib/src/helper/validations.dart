import 'package:get/get.dart';

class Validations {

  static email(value) {
    if(GetUtils.isLengthLessThan(value, 1)) {
      return "Email Field Cannot be Empty";
    } else if(!GetUtils.isEmail(value)) {
      return "Invalid Email";
    } else if(value.contains('+@')) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  static userName(value) {
    final regExp = RegExp(r'^[a-zA-Z一-龠ぁ-ゔァ-ヴー0-9_\-.々〆〤]+$');
    if(GetUtils.isLengthLessThan(value, 1)) {
      return "Name Cannot be Blank".tr;
    } else if(checkForWhiteSpaces(value)) {
      return 'Field Cannot be Empty';
    } else if(!GetUtils.isLengthBetween(value, 4, 20)) {
      return "Value cannot Exceed 20 Characters".tr;
    } else if(!regExp.hasMatch(value)) {
      return 'Invalid Value';
    } else {
      return null;
    }
  }

  static password(value) {
    if(checkForWhiteSpaces(value)) {
      return 'Password cannot be empty';
    } else if(GetUtils.isLengthLessThan(value, 1)) {
      return "Password cannot be empty";
    } else if(!GetUtils.isLengthBetween(value, 6, 20)) {
      return "Password must be 6 to 20 characters long";
    } else {
      return null;
    }
  }

  static isWhiteSpace(value) {
    if(checkForWhiteSpaces(value)) {
      return 'Cannot be empty';
    } else {
      return null;
    }
  }

  static checkForWhiteSpaces(value) {
    if(value!.trim().isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static limit255(value, [validationText]) {
    if(checkForWhiteSpaces(value)) {
      return validationText ?? 'Cannot be empty';
    } else if(GetUtils.isLengthLessThan(value, 1)) {
      return validationText ?? "Cannot be empty";
    } else if(GetUtils.isLengthGreaterThan(value, 255)) {
      return "Max limit 255 reached";
    } else {
      return null;
    }
  }

  static maxLimit255(value) {
    if(GetUtils.isLengthGreaterThan(value, 255)) {
      return "limit255".tr;
    } else {
      return null;
    }
  }

  static checkOtp(value) {
    if(!GetUtils.isLengthEqualTo(value, 6)) {
      return 'OTP Length Limit is 6';
    } else {
      return null;
    }
  } 

  static checkIfNumber(value) {
    if(!GetUtils.isNum(value)) {
      return 'Only numbers allowed';
    } else {
      return null;
    }
  }

}