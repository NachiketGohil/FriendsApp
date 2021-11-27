import 'package:flutter/material.dart';

class Constants {
  static String autoTitle = 'Sign Up', autoButton = 'Sign Up';
  //static String firstName = '', lastName = '', email = '', mobile = '', password = '', searchText = '';
  static TextEditingController controlFirstName = TextEditingController();
  static TextEditingController controlLastName = TextEditingController();
  static TextEditingController controlEmail = TextEditingController();
  static TextEditingController controlMobile = TextEditingController();
  static TextEditingController controlPassword = TextEditingController();
  static TextEditingController controlSearch = TextEditingController();
  static TextInputType typeName = TextInputType.name;
  static TextInputType typeEmail = TextInputType.emailAddress;
  static TextInputType typeNumber = TextInputType.number;
  static TextInputType typePwd = TextInputType.visiblePassword;
  static TextInputAction inputActionNext = TextInputAction.next;
  static TextInputAction inputActionNone = TextInputAction.none;
  static TextCapitalization capitalName = TextCapitalization.words;
  static TextCapitalization capitalNone = TextCapitalization.none;

  static bool isValidateFName() {
    if (controlFirstName.text.isEmpty) {
      return false;
    }
    return true;
  }

  static bool isValidateLName() {
    if (controlLastName.text.isEmpty) {
      return false;
    }
    return true;
  }

  static bool isValidateEmail() {
    bool validEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(controlEmail.text);
    if (controlEmail.text.isEmpty) {
      return false;
    } else if (!validEmail) {
      return false;
    }
    return true;
  }

  static bool isValidateMobile() {
    if (controlMobile.text.isEmpty) {
      return false;
    } else if (controlMobile.text.length != 10) {
      return false;
    }
    return true;
  }

  static bool isValidatePassword() {
    if (controlPassword.text.isEmpty) {
      return false;
    } else if (controlPassword.text.length < 4) {
      return false;
    }
    return true;
  }
}
