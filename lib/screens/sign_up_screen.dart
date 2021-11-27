import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_app/database/db_helper.dart';
import 'package:friends_app/constant.dart';
import 'package:friends_app/widgets/custom_button.dart';
import 'package:friends_app/widgets/custom_textfield.dart';
import 'package:friends_app/widgets/error_snackbar.dart';

import 'friend_list.dart';

/**
 * This is Multi purpose Screen, Everything is being reused
 */

class SignUpScreen extends StatefulWidget {
  String autoTitle = '', autoButton = '';

  SignUpScreen({
    required this.autoTitle,
    required this.autoButton,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState(
        this.autoTitle,
        this.autoButton,
      );
}

class _SignUpScreenState extends State<SignUpScreen> {
  //Future<List<FriendsModel>>? mListFriends;
  List<Map<String, dynamic>> _friendList = [];
  int? frndIdForUpdate;
  //DBHelper? dbHelper;
  String? firstName = '', lastName = '', email = '', mobile = '', password = '';
  bool isLogin = false;
  String autoTitle, autoButton;

  _SignUpScreenState(
    this.autoTitle,
    this.autoButton,
  );

  @override
  Widget build(BuildContext context) {
    autoTitle = isLogin ? "Login Here" : 'SignUp Here';
    autoButton = isLogin ? "Login" : 'SignUp';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(autoTitle),
      ),
      body: Builder(
        builder: (context) => ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(13),
          children: [
            Visibility(
              visible: !isLogin,
              child: CustomTextfield(
                cuLabelText: 'First Name',
                // cuOnChanged: (text) => Constants.firstName = text,
                textController: Constants.controlFirstName,
                cuTextCapitalization: Constants.capitalName,
                cuKeyboardType: Constants.typeName,
                cuTextInputAction: Constants.inputActionNext,
              ),
            ),
            Visibility(
              visible: !isLogin,
              child: CustomTextfield(
                cuLabelText: 'Last Name',
                //cuOnChanged: (text) => Constants.lastName = text,
                textController: Constants.controlLastName,
                cuTextCapitalization: Constants.capitalName,
                cuKeyboardType: Constants.typeName,
                cuTextInputAction: Constants.inputActionNext,
              ),
            ),
            Visibility(
              visible: !isLogin,
              child: CustomTextfield(
                cuLabelText: 'Email',
                //cuOnChanged: (text) => Constants.email = text,
                textController: Constants.controlEmail,
                cuTextCapitalization: Constants.capitalNone,
                cuKeyboardType: Constants.typeEmail,
                cuTextInputAction: Constants.inputActionNext,
              ),
            ),
            CustomTextfield(
              cuLabelText: 'Mobile Number',
              //cuOnChanged: (text) => Constants.mobile = text,
              textController: Constants.controlMobile,
              cuTextCapitalization: Constants.capitalNone,
              cuKeyboardType: Constants.typeNumber,
              cuTextInputAction: Constants.inputActionNext,
            ),
            CustomTextfield(
              cuLabelText: 'Create Password',
              //cuOnChanged: (text) => Constants.password = text,
              textController: Constants.controlPassword,
              cuTextCapitalization: Constants.capitalNone,
              cuKeyboardType: Constants.typePwd,
              cuTextInputAction: Constants.inputActionNone,
            ),
            CustomButton(
              onPressedButton: () {
                if (isLogin) {
                  ///only login with mobile and pwd
                  if (Constants.isValidateMobile() &&
                      Constants.isValidatePassword()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Logging In...',
                      wantLoading: false,
                    );
                  }
                  Timer(
                    const Duration(seconds: 2),
                    () =>
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => FriendList(),
                    )),
                  );
                } else {
                  ///do signup
                  print("SIgn up Clicked");
                  FocusScope.of(context).unfocus();
                  if (!Constants.isValidateFName()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter First Name',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateLName()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter Last Name',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateEmail()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: 'Please Enter Valid Email',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidateMobile()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg:
                          'Please Enter Mobile Number with Only 10 digits',
                      wantLoading: false,
                    );
                  } else if (!Constants.isValidatePassword()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg:
                          'Please Enter password with at least 4 characters',
                      wantLoading: false,
                    );
                  } else if (Constants.isValidateFName() &&
                      Constants.isValidateLName() &&
                      Constants.isValidateEmail() &&
                      Constants.isValidateMobile() &&
                      Constants.isValidatePassword()) {
                    ErrorSnackbar.buildErrorSnackbar(
                      context: context,
                      errorMsg: "Signing Up...",
                      wantLoading: true,
                    );

                    log(
                      "All the values in the variables are: \n"
                      "firstName: ${Constants.controlFirstName.text}\n"
                      "lastName: ${Constants.controlLastName.text}\n"
                      "email: ${Constants.controlEmail.text}\n"
                      "mobile: ${Constants.controlMobile.text}\n"
                      "password: ${Constants.controlPassword.text}\n",
                      level: 2,
                      name: "VALUES IN VARIABLES",
                    );

                    _addFriend();
                    setState(() {
                      isLogin = true;
                    });
                    Constants.controlMobile.clear();
                    Constants.controlPassword.clear();
                    // Timer(
                    //   const Duration(seconds: 2),
                    //   () => Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (context) => FriendList(),
                    //     ),
                    //   ),
                    // );
                  }
                }
              },
              autoButton: autoButton,
            ),
          ],
        ),
      ),
    );
  }

  // Insert a new journal to the database
  Future<void> _addFriend() async {
    await DbHelper.createFriend(
        cFirstName: Constants.controlFirstName.text,
        cLastName: Constants.controlLastName.text,
        cEmail: Constants.controlEmail.text,
        cMobile: Constants.controlMobile.text,
        cPassword: Constants.controlPassword.text);
  }
}
